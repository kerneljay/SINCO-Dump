const wallets = [
    { id: 'chips', ticker: 'CHIP', name: 'Casino chips', icon: 'S', playable: true },
    { id: 'bank', ticker: 'BANK', name: 'SINCO bank', icon: '£', playable: false }
];

let chips = 0;
let bank = 0;
let selected = wallets[0];
let cashierMode = 'deposit';
let cashierBusy = false;
let liveCasino = typeof window.invokeNative === 'function';
const MIN_BET = 10000;
const MAX_BET = 500000000;

const money = (n) => '£' + Math.floor(Number(n) || 0).toLocaleString('en-GB');

async function nui(event, data) {
    try {
        if (typeof fetchNui === 'function') {
            return await fetchNui(event, data || {});
        }
        if (liveCasino && typeof GetParentResourceName === 'function') {
            const resp = await fetch('https://' + GetParentResourceName() + '/' + event, {
                method: 'POST',
                body: JSON.stringify(data || {})
            });
            return await resp.json();
        }
    } catch (e) {}
    return null;
}

function applyBalance(nextChips, nextBank) {
    if (nextChips != null) chips = Math.max(0, Math.floor(Number(nextChips) || 0));
    if (nextBank != null) bank = Math.max(0, Math.floor(Number(nextBank) || 0));
    syncWallet();
}

function walletValue(id) {
    return id === 'bank' ? bank : chips;
}

function setSelected(wallet) {
    selected = wallet;
    document.getElementById('currentCoin').dataset.ticker = wallet.ticker;
    document.getElementById('currentCoin').textContent = wallet.icon;
    document.getElementById('currentValue').textContent = money(walletValue(wallet.id));
    document.getElementById('cashierCoin').textContent = 'CHIPS';
    document.getElementById('cashierValue').textContent = money(chips);
    const bankEl = document.getElementById('cashierBank');
    if (bankEl) bankEl.textContent = 'Bank ' + money(bank);
}

function renderWalletOptions(filter = '') {
    const q = filter.trim().toLowerCase();
    const root = document.getElementById('walletOptions');
    root.innerHTML = '';
    wallets
        .filter((w) => !q || w.ticker.toLowerCase().includes(q) || w.name.toLowerCase().includes(q))
        .forEach((wallet) => {
            const row = document.createElement('button');
            row.type = 'button';
            row.className = 'w-option';
            row.innerHTML =
                `<span><span class="coin" data-ticker="${wallet.ticker}">${wallet.icon}</span>&nbsp;${wallet.ticker}</span>` +
                `<span>${money(walletValue(wallet.id))}</span>`;
            row.addEventListener('click', () => {
                setSelected(wallet);
                document.getElementById('walletWrap').classList.remove('sw-active');
            });
            root.appendChild(row);
        });
}

function syncWallet() {
    setSelected(selected);
    renderWalletOptions(document.getElementById('walletSearch').value);
}

function setSidebar(open) {
    document.getElementById('sidebar').classList.toggle('is-open', open);
    document.getElementById('sidebarDim').classList.toggle('is-on', open);
}

window.setTimeout(() => {
    document.getElementById('intro').classList.add('is-gone');
}, 2000);

document.getElementById('openSidebar').addEventListener('click', () => setSidebar(true));
document.getElementById('closeSidebar').addEventListener('click', () => setSidebar(false));
document.getElementById('sidebarDim').addEventListener('click', () => setSidebar(false));

document.getElementById('walletToggle').addEventListener('click', () => {
    document.getElementById('walletWrap').classList.toggle('sw-active');
});

document.getElementById('walletSearch').addEventListener('input', (e) => {
    renderWalletOptions(e.target.value);
});

document.getElementById('openCashier').addEventListener('click', () => {
    document.getElementById('walletWrap').classList.remove('sw-active');
    document.getElementById('cashier').classList.add('is-open');
});

document.getElementById('closeCashier').addEventListener('click', () => {
    document.getElementById('cashier').classList.remove('is-open');
});

document.querySelectorAll('.st-seg-btn').forEach((btn) => {
    btn.addEventListener('click', () => {
        document.querySelectorAll('.st-seg-btn').forEach((b) => b.classList.remove('is-on'));
        btn.classList.add('is-on');
        cashierMode = btn.dataset.mode;
        document.getElementById('cashierGo').textContent =
            cashierMode === 'deposit' ? 'Deposit' : 'Withdraw';
    });
});

document.getElementById('cashierGo').addEventListener('click', async () => {
    if (cashierBusy) return;
    const amount = Math.floor(Number(document.getElementById('cashierAmount').value) || 0);
    if (amount < 1) return;
    if (!liveCasino) {
        if (cashierMode === 'deposit') {
            if (amount > bank) return;
            chips += amount;
            bank -= amount;
        } else {
            if (amount > chips) return;
            chips -= amount;
            bank += amount;
        }
        syncWallet();
        return;
    }
    cashierBusy = true;
    const res = await nui('casinoCashier', { mode: cashierMode, amount });
    cashierBusy = false;
    if (!res || !res.ok) {
        document.getElementById('cashierGo').textContent = (res && res.error) || 'Failed';
        setTimeout(() => {
            document.getElementById('cashierGo').textContent =
                cashierMode === 'deposit' ? 'Deposit' : 'Withdraw';
        }, 1400);
        return;
    }
    applyBalance(res.chips, res.bank);
});

document.addEventListener('click', (e) => {
    const wrap = document.getElementById('walletWrap');
    if (!wrap.contains(e.target)) wrap.classList.remove('sw-active');
});

renderWalletOptions();
setSelected(selected);

const suits = [
    { s: '♠', red: false },
    { s: '♥', red: true },
    { s: '♦', red: true },
    { s: '♣', red: false }
];
const ranks = ['A', '2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K'];

let deck = [];
let playerHand = [];
let dealerHand = [];
let bjBet = 0;
let bjLive = false;
let bjBusy = false;
let audioCtx = null;

function wait(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}

function playTone(freq, dur, type, vol) {
    try {
        audioCtx = audioCtx || new (window.AudioContext || window.webkitAudioContext)();
        const osc = audioCtx.createOscillator();
        const gain = audioCtx.createGain();
        osc.type = type || 'triangle';
        osc.frequency.value = freq;
        gain.gain.value = vol || 0.05;
        osc.connect(gain);
        gain.connect(audioCtx.destination);
        osc.start();
        gain.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + dur);
        osc.stop(audioCtx.currentTime + dur);
    } catch (e) {}
}

function sfxDeal() { playTone(520, 0.07, 'triangle', 0.045); }
function sfxClick() { playTone(300, 0.04, 'square', 0.03); }
function sfxWin() {
    playTone(660, 0.09, 'triangle', 0.05);
    setTimeout(() => playTone(880, 0.14, 'triangle', 0.05), 90);
}
function sfxLose() { playTone(150, 0.2, 'sawtooth', 0.04); }

function shuffleDeck() {
    deck = [];
    suits.forEach((suit) => {
        ranks.forEach((rank) => deck.push({ rank, suit: suit.s, red: suit.red }));
    });
    for (let i = deck.length - 1; i > 0; i--) {
        const j = Math.floor(Math.random() * (i + 1));
        [deck[i], deck[j]] = [deck[j], deck[i]];
    }
}

function drawCard() {
    if (!deck.length) shuffleDeck();
    return deck.pop();
}

function handValue(hand) {
    let total = 0;
    let aces = 0;
    hand.forEach((card) => {
        if (!card || card.hidden) return;
        if (card.rank === 'A') {
            total += 11;
            aces += 1;
        } else if (['J', 'Q', 'K'].includes(card.rank)) {
            total += 10;
        } else {
            total += Number(card.rank);
        }
    });
    while (total > 21 && aces) {
        total -= 10;
        aces -= 1;
    }
    return total;
}

function makeCard(card, hide, flip) {
    const div = document.createElement('div');
    if (hide || (card && card.hidden)) {
        div.className = 'bj-card back';
        div.textContent = 'SINCO';
    } else {
        div.className = 'bj-card' + (card.red ? ' red' : '') + (flip ? ' flip' : '');
        div.innerHTML = `<span>${card.rank}</span><span>${card.suit}</span>`;
    }
    return div;
}

async function dealCard(el, card, hide) {
    sfxDeal();
    el.appendChild(makeCard(card, hide, false));
    await wait(170);
}

function setBjPlaying(playing) {
    bjLive = playing;
    document.getElementById('bjDeal').disabled = playing || bjBusy;
    document.getElementById('bjHit').disabled = !playing || bjBusy;
    document.getElementById('bjStand').disabled = !playing || bjBusy;
    document.getElementById('bjBet').disabled = playing || bjBusy;
    const pair = document.getElementById('bjPairBet');
    const three = document.getElementById('bjThreeBet');
    if (pair) pair.disabled = playing || bjBusy;
    if (three) three.disabled = playing || bjBusy;
}

function clampBet(value, allowZero) {
    let amount = Math.floor(Number(value) || 0);
    if (allowZero && amount <= 0) return 0;
    if (amount < MIN_BET) amount = MIN_BET;
    if (amount > MAX_BET) amount = MAX_BET;
    return amount;
}

function sideBetValue(id) {
    const raw = Math.floor(Number(document.getElementById(id).value) || 0);
    if (raw <= 0) return 0;
    return clampBet(raw, false);
}

function rankValue(rank) {
    if (rank === 'A') return 1;
    if (rank === 'J') return 11;
    if (rank === 'Q') return 12;
    if (rank === 'K') return 13;
    return Number(rank);
}

function perfectPairsOdds(c1, c2) {
    if (!c1 || !c2 || c1.rank !== c2.rank) return [0, ''];
    if (c1.suit === c2.suit) return [25, 'Perfect Pair 25:1'];
    if (c1.red === c2.red) return [12, 'Coloured Pair 12:1'];
    return [6, 'Mixed Pair 6:1'];
}

function twentyOneThreeOdds(c1, c2, up) {
    if (!c1 || !c2 || !up) return [0, ''];
    const flush = c1.suit === c2.suit && c2.suit === up.suit;
    const trips = c1.rank === c2.rank && c2.rank === up.rank;
    const vals = [rankValue(c1.rank), rankValue(c2.rank), rankValue(up.rank)].sort((a, b) => a - b);
    const unique = vals[0] !== vals[1] && vals[1] !== vals[2];
    const straight = unique && ((vals[0] === 1 && vals[1] === 12 && vals[2] === 13) || (vals[0] + 1 === vals[1] && vals[1] + 1 === vals[2]));
    if (trips && flush) return [100, 'Suited Trips 100:1'];
    if (straight && flush) return [40, 'Straight Flush 40:1'];
    if (trips) return [30, 'Three of a Kind 30:1'];
    if (straight) return [10, 'Straight 10:1'];
    if (flush) return [5, 'Flush 5:1'];
    return [0, ''];
}

function sideResultText(pairBet, threeBet, c1, c2, up) {
    const notes = [];
    let payout = 0;
    if (pairBet > 0) {
        const [odds, label] = perfectPairsOdds(c1, c2);
        if (odds) {
            payout += pairBet * (odds + 1);
            notes.push(label);
        }
    }
    if (threeBet > 0) {
        const [odds, label] = twentyOneThreeOdds(c1, c2, up);
        if (odds) {
            payout += threeBet * (odds + 1);
            notes.push(label);
        }
    }
    if (!notes.length && (pairBet > 0 || threeBet > 0)) return { payout: 0, note: 'Side bets lost' };
    return { payout, note: notes.join(' + ') };
}

const BJ_LABELS = {
    play: 'Hit or stand',
    blackjack: 'Blackjack',
    push: 'Push',
    lose: 'Dealer wins',
    bust: 'Bust',
    dealer_bust: 'Dealer busts',
    win: 'You win'
};

function statusWithSide(state, sideNote) {
    const base = BJ_LABELS[state] || state;
    return sideNote ? base + ' · ' + sideNote : base;
}

async function settle(result, payout, sideNote) {
    if (!liveCasino) {
        chips = Math.max(0, chips + payout);
        syncWallet();
    }
    document.getElementById('bjStatus').textContent = statusWithSide(result, sideNote);
    document.getElementById('dealerTotal').textContent = handValue(dealerHand.filter((c) => !c.hidden));
    const dealerEl = document.getElementById('dealerCards');
    dealerEl.innerHTML = '';
    dealerHand.forEach((card, i) => dealerEl.appendChild(makeCard(card, !!card.hidden, i === 1)));
    if (payout > bjBet) sfxWin();
    else if (payout === 0) sfxLose();
    else sfxClick();
    bjBusy = false;
    setBjPlaying(false);
}

function openGame(name) {
    sfxClick();
    setSidebar(false);
    const page = document.querySelector('.odds-page');
    page.classList.remove('playing-bj', 'playing-roulette');
    page.classList.add(name);
}

function closeGame() {
    sfxClick();
    document.querySelector('.odds-page').classList.remove('playing-bj', 'playing-roulette');
}

document.getElementById('openBlackjack').addEventListener('click', () => openGame('playing-bj'));
document.getElementById('sidebarBlackjack').addEventListener('click', () => openGame('playing-bj'));
document.getElementById('closeBlackjack').addEventListener('click', closeGame);
document.getElementById('openRoulette').addEventListener('click', () => openGame('playing-roulette'));
document.getElementById('sidebarRoulette').addEventListener('click', () => openGame('playing-roulette'));
document.getElementById('closeRoulette').addEventListener('click', closeGame);

document.getElementById('bjHalf').addEventListener('click', () => {
    sfxClick();
    document.getElementById('bjBet').value = clampBet(Math.floor(Number(document.getElementById('bjBet').value) / 2));
});
document.getElementById('bjDouble').addEventListener('click', () => {
    sfxClick();
    document.getElementById('bjBet').value = clampBet(Number(document.getElementById('bjBet').value) * 2);
});

async function dealFromHands(player, dealer, hideHole) {
    document.getElementById('playerCards').innerHTML = '';
    document.getElementById('dealerCards').innerHTML = '';
    await dealCard(document.getElementById('playerCards'), player[0], false);
    document.getElementById('playerTotal').textContent = handValue([player[0]]);
    await dealCard(document.getElementById('dealerCards'), dealer[0], false);
    document.getElementById('dealerTotal').textContent = handValue([dealer[0]]);
    await dealCard(document.getElementById('playerCards'), player[1], false);
    document.getElementById('playerTotal').textContent = handValue(player);
    await dealCard(document.getElementById('dealerCards'), dealer[1] || { hidden: true }, hideHole);
}

document.getElementById('bjDeal').addEventListener('click', async () => {
    if (bjBusy || bjLive) return;
    const amount = clampBet(document.getElementById('bjBet').value);
    const pairBet = sideBetValue('bjPairBet');
    const threeBet = sideBetValue('bjThreeBet');
    document.getElementById('bjBet').value = amount;
    const total = amount + pairBet + threeBet;
    if (total > chips) {
        document.getElementById('bjStatus').textContent = 'Not enough chips';
        sfxLose();
        return;
    }
    bjBet = amount;
    document.getElementById('bjStatus').textContent = 'Dealing...';
    bjBusy = true;
    setBjPlaying(false);

    if (liveCasino) {
        const res = await nui('casinoBlackjackStart', { amount, pairBet, threeBet });
        if (!res || !res.ok) {
            document.getElementById('bjStatus').textContent = (res && res.error) || 'Bet failed';
            bjBusy = false;
            setBjPlaying(false);
            sfxLose();
            return;
        }
        applyBalance(res.chips, res.bank);
        playerHand = res.player || [];
        dealerHand = res.dealer || [];
        await dealFromHands(playerHand, dealerHand, res.state === 'play');
        if (res.state === 'play') {
            document.getElementById('bjStatus').textContent = statusWithSide('play', res.sideNote);
            document.getElementById('playerTotal').textContent = res.playerTotal;
            document.getElementById('dealerTotal').textContent = res.dealerTotal;
            bjBusy = false;
            setBjPlaying(true);
            return;
        }
        dealerHand = res.dealer || dealerHand;
        await settle(res.state, res.payout, res.sideNote);
        applyBalance(res.chips, res.bank);
        document.getElementById('playerTotal').textContent = res.playerTotal;
        document.getElementById('dealerTotal').textContent = res.dealerTotal;
        return;
    }

    chips -= total;
    syncWallet();
    shuffleDeck();
    playerHand = [];
    dealerHand = [];
    playerHand.push(drawCard());
    dealerHand.push(drawCard());
    playerHand.push(drawCard());
    dealerHand.push(drawCard());
    const sides = sideResultText(pairBet, threeBet, playerHand[0], playerHand[1], dealerHand[0]);
    chips += sides.payout;
    syncWallet();
    await dealFromHands(playerHand, dealerHand, true);
    const player = handValue(playerHand);
    const dealer = handValue(dealerHand);
    document.getElementById('playerTotal').textContent = player;
    if (player === 21 && dealer === 21) {
        await settle('push', bjBet, sides.note);
        return;
    }
    if (player === 21) {
        const payout = bjBet + Math.floor((bjBet * 6) / 5);
        await settle('blackjack', payout, sides.note);
        return;
    }
    if (dealer === 21) {
        await settle('lose', 0, sides.note);
        return;
    }
    document.getElementById('bjStatus').textContent = statusWithSide('play', sides.note);
    document.getElementById('dealerTotal').textContent = handValue([dealerHand[0]]);
    bjBusy = false;
    setBjPlaying(true);
});

document.getElementById('bjHit').addEventListener('click', async () => {
    if (!bjLive || bjBusy) return;
    bjBusy = true;
    setBjPlaying(true);
    if (liveCasino) {
        const res = await nui('casinoBlackjackHit');
        if (!res || !res.ok) {
            document.getElementById('bjStatus').textContent = (res && res.error) || 'Hit failed';
            bjBusy = false;
            setBjPlaying(true);
            return;
        }
        applyBalance(res.chips, res.bank);
        const next = res.player[res.player.length - 1];
        playerHand = res.player;
        await dealCard(document.getElementById('playerCards'), next, false);
        document.getElementById('playerTotal').textContent = res.playerTotal;
        if (res.state !== 'play') {
            dealerHand = res.dealer || dealerHand;
            await settle(res.state, res.payout, res.sideNote);
            applyBalance(res.chips, res.bank);
            return;
        }
        bjBusy = false;
        setBjPlaying(true);
        return;
    }
    playerHand.push(drawCard());
    await dealCard(document.getElementById('playerCards'), playerHand[playerHand.length - 1], false);
    const total = handValue(playerHand);
    document.getElementById('playerTotal').textContent = total;
    if (total > 21) {
        await settle('bust', 0);
        return;
    }
    bjBusy = false;
    setBjPlaying(true);
});

document.getElementById('bjStand').addEventListener('click', async () => {
    if (!bjLive || bjBusy) return;
    bjBusy = true;
    setBjPlaying(true);
    if (liveCasino) {
        const res = await nui('casinoBlackjackStand');
        if (!res || !res.ok) {
            document.getElementById('bjStatus').textContent = (res && res.error) || 'Stand failed';
            bjBusy = false;
            setBjPlaying(true);
            return;
        }
        applyBalance(res.chips, res.bank);
        dealerHand = res.dealer || [];
        const dealerEl = document.getElementById('dealerCards');
        dealerEl.innerHTML = '';
        for (let i = 0; i < dealerHand.length; i++) {
            await dealCard(dealerEl, dealerHand[i], false);
            document.getElementById('dealerTotal').textContent = handValue(dealerHand.slice(0, i + 1));
        }
        document.getElementById('playerTotal').textContent = res.playerTotal;
        await settle(res.state, res.payout, res.sideNote);
        applyBalance(res.chips, res.bank);
        return;
    }
    const dealerEl = document.getElementById('dealerCards');
    dealerEl.innerHTML = '';
    dealerHand.forEach((card, i) => dealerEl.appendChild(makeCard(card, false, i === 1)));
    sfxDeal();
    document.getElementById('dealerTotal').textContent = handValue(dealerHand);
    await wait(220);
    while (handValue(dealerHand) < 17) {
        dealerHand.push(drawCard());
        await dealCard(dealerEl, dealerHand[dealerHand.length - 1], false);
        document.getElementById('dealerTotal').textContent = handValue(dealerHand);
    }
    const player = handValue(playerHand);
    const dealer = handValue(dealerHand);
    document.getElementById('playerTotal').textContent = player;
    if (dealer > 21) {
        await settle('dealer_bust', bjBet * 2);
    } else if (player > dealer) {
        await settle('win', bjBet * 2);
    } else if (player < dealer) await settle('lose', 0);
    else {
        await settle('push', bjBet);
    }
});

const WHEEL_ORDER = [0, 32, 15, 19, 4, 21, 2, 25, 17, 34, 6, 27, 13, 36, 11, 30, 8, 23, 10, 5, 24, 16, 33, 1, 20, 14, 31, 9, 22, 18, 29, 7, 28, 12, 35, 3, 26];
const reds = [1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36];
const rlBets = new Map();
let rlBusy = false;
let rlWheelRot = 0;

function rlColor(n) {
    if (n === 0) return 'green';
    return reds.includes(n) ? 'red' : 'black';
}

function rlOdds(spot) {
    if (spot.startsWith('n-')) return 35;
    if (spot.startsWith('col-') || spot.startsWith('doz-')) return 2;
    return 1;
}

function rlWins(spot, n) {
    if (spot === 'n-' + n) return true;
    if (spot === 'red') return rlColor(n) === 'red';
    if (spot === 'black') return rlColor(n) === 'black';
    if (spot === 'even') return n !== 0 && n % 2 === 0;
    if (spot === 'odd') return n % 2 === 1;
    if (spot === 'low') return n >= 1 && n <= 18;
    if (spot === 'high') return n >= 19 && n <= 36;
    if (spot === 'doz-1') return n >= 1 && n <= 12;
    if (spot === 'doz-2') return n >= 13 && n <= 24;
    if (spot === 'doz-3') return n >= 25 && n <= 36;
    if (spot === 'col-1') return n > 0 && n % 3 === 1;
    if (spot === 'col-2') return n > 0 && n % 3 === 2;
    if (spot === 'col-3') return n > 0 && n % 3 === 0;
    return false;
}

function formatChip(n) {
    if (n >= 1000) return Math.round(n / 100) / 10 + 'k';
    return String(n);
}

function polar(cx, cy, r, deg) {
    const rad = ((deg - 90) * Math.PI) / 180;
    return [cx + r * Math.cos(rad), cy + r * Math.sin(rad)];
}

function buildRouletteWheel() {
    const svg = document.getElementById('rlWheel');
    svg.innerHTML = '';
    const size = 280;
    const cx = size / 2;
    const cy = size / 2;
    const outer = 138;
    const inner = 68;
    const textR = 106;
    const step = 360 / WHEEL_ORDER.length;
    const rim = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    rim.setAttribute('cx', cx);
    rim.setAttribute('cy', cy);
    rim.setAttribute('r', 139.5);
    rim.setAttribute('fill', '#0a151d');
    svg.appendChild(rim);
    WHEEL_ORDER.forEach((n, i) => {
        const a0 = i * step;
        const a1 = (i + 1) * step;
        const [x0, y0] = polar(cx, cy, outer, a0);
        const [x1, y1] = polar(cx, cy, outer, a1);
        const [ix0, iy0] = polar(cx, cy, inner, a1);
        const [ix1, iy1] = polar(cx, cy, inner, a0);
        const path = document.createElementNS('http://www.w3.org/2000/svg', 'path');
        path.setAttribute(
            'd',
            `M ${x0} ${y0} A ${outer} ${outer} 0 0 1 ${x1} ${y1} L ${ix0} ${iy0} A ${inner} ${inner} 0 0 0 ${ix1} ${iy1} Z`
        );
        const color = rlColor(n);
        path.setAttribute('fill', color === 'green' ? '#1db954' : color === 'red' ? '#e5394a' : '#1c242c');
        svg.appendChild(path);
        const mid = a0 + step / 2;
        const [tx, ty] = polar(cx, cy, textR, mid);
        const text = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        text.setAttribute('x', tx);
        text.setAttribute('y', ty);
        text.setAttribute('fill', '#fff');
        text.setAttribute('font-size', '13');
        text.setAttribute('font-weight', '800');
        text.setAttribute('font-family', 'Poppins, sans-serif');
        text.setAttribute('text-anchor', 'middle');
        text.setAttribute('dominant-baseline', 'middle');
        text.setAttribute('transform', `rotate(${mid} ${tx} ${ty})`);
        text.textContent = String(n);
        svg.appendChild(text);
    });
    const hub = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    hub.setAttribute('cx', cx);
    hub.setAttribute('cy', cy);
    hub.setAttribute('r', 60);
    hub.setAttribute('fill', '#0F212E');
    svg.appendChild(hub);
    const gold = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
    gold.setAttribute('cx', cx);
    gold.setAttribute('cy', cy);
    gold.setAttribute('r', 22);
    gold.setAttribute('fill', '#e6c14a');
    svg.appendChild(gold);
}

function chipTotal() {
    let total = 0;
    rlBets.forEach((stack) => stack.forEach((n) => (total += n)));
    return total;
}

function renderChipStack(btn, amounts) {
    let stack = btn.querySelector('.rl-chips');
    if (!amounts.length) {
        if (stack) stack.remove();
        return;
    }
    if (!stack) {
        stack = document.createElement('span');
        stack.className = 'rl-chips';
        btn.appendChild(stack);
    }
    stack.innerHTML = '';
    const show = amounts.slice(-3);
    const total = amounts.reduce((a, b) => a + b, 0);
    show.forEach((_, i) => {
        const chip = document.createElement('span');
        chip.className = 'rl-chip';
        chip.style.setProperty('--i', String(i));
        chip.textContent = formatChip(i === show.length - 1 ? total : amounts[amounts.length - show.length + i]);
        stack.appendChild(chip);
    });
}

function makeRlCell(label, spot, cls) {
    const btn = document.createElement('button');
    btn.type = 'button';
    btn.className = 'rl-cell ' + cls;
    btn.dataset.spot = spot;
    const text = document.createElement('span');
    text.textContent = label;
    btn.appendChild(text);
    btn.addEventListener('click', () => {
        if (rlBusy) return;
        const amount = clampBet(document.getElementById('rlBet').value);
        document.getElementById('rlBet').value = amount;
        if (chipTotal() + amount > MAX_BET) return;
        if (chipTotal() + amount > chips) {
            document.getElementById('rlStatus').textContent = 'Not enough chips';
            return;
        }
        sfxClick();
        const stack = rlBets.get(spot) || [];
        stack.push(amount);
        rlBets.set(spot, stack);
        renderChipStack(btn, stack);
        document.getElementById('rlStatus').textContent = money(chipTotal()) + ' on the table';
    });
    return btn;
}

function buildRouletteBoard() {
    const board = document.getElementById('rlBoard');
    board.innerHTML = '';
    board.appendChild(makeRlCell('0', 'n-0', 'green rl-zero'));
    const rows = [
        [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36],
        [2, 5, 8, 11, 14, 17, 20, 23, 26, 29, 32, 35],
        [1, 4, 7, 10, 13, 16, 19, 22, 25, 28, 31, 34]
    ];
    rows.forEach((row, r) => {
        row.forEach((n, c) => {
            const cell = makeRlCell(String(n), 'n-' + n, rlColor(n));
            cell.style.gridColumn = String(c + 2);
            cell.style.gridRow = String(r + 1);
            board.appendChild(cell);
        });
    });
    [
        ['1 to 12', 'doz-1', 2, 4],
        ['13 to 24', 'doz-2', 6, 4],
        ['25 to 36', 'doz-3', 10, 4]
    ].forEach(([label, spot, col, span]) => {
        const cell = makeRlCell(label, spot, 'out');
        cell.style.gridColumn = col + ' / span ' + span;
        cell.style.gridRow = '4';
        board.appendChild(cell);
    });
    [
        ['1 to 18', 'low'],
        ['EVEN', 'even'],
        ['RED', 'red'],
        ['BLACK', 'black'],
        ['ODD', 'odd'],
        ['19 to 36', 'high']
    ].forEach(([label, spot], i) => {
        const extra = spot === 'red' ? ' red' : spot === 'black' ? ' black' : '';
        const cell = makeRlCell(label, spot, 'out' + extra);
        cell.style.gridColumn = 2 + i * 2 + ' / span 2';
        cell.style.gridRow = '5';
        board.appendChild(cell);
    });
}

function clearRoulette() {
    rlBets.clear();
    document.querySelectorAll('.rl-cell').forEach((el) => {
        el.classList.remove('hit');
        const stack = el.querySelector('.rl-chips');
        if (stack) stack.remove();
    });
    document.getElementById('rlStatus').textContent = 'Tap numbers to place chips';
    document.getElementById('rlHit').textContent = '-';
}

buildRouletteWheel();
buildRouletteBoard();

document.getElementById('rlClear').addEventListener('click', () => {
    sfxClick();
    clearRoulette();
});

document.getElementById('rlHalf').addEventListener('click', () => {
    sfxClick();
    document.getElementById('rlBet').value = clampBet(Math.floor(Number(document.getElementById('rlBet').value) / 2));
});
document.getElementById('rlDouble').addEventListener('click', () => {
    sfxClick();
    document.getElementById('rlBet').value = clampBet(Number(document.getElementById('rlBet').value) * 2);
});

document.getElementById('rlSpin').addEventListener('click', async () => {
    if (rlBusy) return;
    const cost = chipTotal();
    if (cost < MIN_BET) {
        document.getElementById('rlStatus').textContent = 'Min bet is £10,000';
        return;
    }
    if (cost > MAX_BET) {
        document.getElementById('rlStatus').textContent = 'Max bet is £500,000,000';
        return;
    }
    if (cost > chips) {
        document.getElementById('rlStatus').textContent = 'Not enough chips';
        sfxLose();
        return;
    }
    rlBusy = true;
    document.getElementById('rlSpin').disabled = true;
    document.getElementById('rlStatus').textContent = 'Spinning...';
    document.querySelectorAll('.rl-cell.hit').forEach((el) => el.classList.remove('hit'));
    playTone(220, 0.12, 'triangle', 0.04);

    const bets = {};
    rlBets.forEach((stack, spot) => {
        bets[spot] = stack.reduce((a, b) => a + b, 0);
    });

    let number;
    let payout = 0;
    let color;

    if (liveCasino) {
        const res = await nui('casinoRouletteSpin', { bets });
        if (!res || !res.ok) {
            document.getElementById('rlStatus').textContent = (res && res.error) || 'Spin failed';
            rlBusy = false;
            document.getElementById('rlSpin').disabled = false;
            sfxLose();
            return;
        }
        applyBalance(res.chips, res.bank);
        number = res.number;
        payout = res.payout;
        color = res.color;
    } else {
        chips -= cost;
        syncWallet();
        number = Math.floor(Math.random() * 37);
        color = rlColor(number);
        rlBets.forEach((stack, spot) => {
            if (!rlWins(spot, number)) return;
            stack.forEach((chip) => {
                payout += chip * (rlOdds(spot) + 1);
            });
        });
        chips += payout;
        syncWallet();
    }

    const idx = WHEEL_ORDER.indexOf(number);
    const step = 360 / WHEEL_ORDER.length;
    const target = -(idx * step + step / 2);
    rlWheelRot += 360 * 5 + ((target - (rlWheelRot % 360) + 360) % 360);
    document.getElementById('rlWheel').style.transform = 'rotate(' + rlWheelRot + 'deg)';
    await wait(2700);
    const hit = document.querySelector('.rl-cell[data-spot="n-' + number + '"]');
    if (hit) hit.classList.add('hit');
    document.getElementById('rlHit').textContent = number + '  ' + String(color).toUpperCase();
    document.getElementById('rlHit').style.color =
        color === 'red' ? '#ed4163' : color === 'green' ? '#3dd68c' : '#fff';
    if (payout) {
        document.getElementById('rlStatus').textContent = 'You win ' + money(payout);
        sfxWin();
    } else {
        document.getElementById('rlStatus').textContent = 'No win';
        sfxLose();
    }
    rlBusy = false;
    document.getElementById('rlSpin').disabled = false;
});

if (typeof onSettingsChange === 'function') {
    onSettingsChange((settings) => {
        document.querySelector('.app').dataset.theme = settings.display.theme;
    });
}
if (typeof getSettings === 'function') {
    getSettings().then((settings) => {
        document.querySelector('.app').dataset.theme = settings.display.theme;
    });
}

window.addEventListener('message', (e) => {
    const data = e.data;
    if (!data || typeof data !== 'object') return;
    if (data.type === 'casinoSetBalance') {
        applyBalance(data.chips, data.bank);
    }
});

nui('casinoGetState').then((res) => {
    if (res && res.ok) applyBalance(res.chips, res.bank);
});
