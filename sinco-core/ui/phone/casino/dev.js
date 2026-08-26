// Browser-only phone frame from the LB Phone vanilla template.
window.addEventListener('load', () => {
    const phoneWrapper = document.getElementById('phone-wrapper');
    const app = phoneWrapper.querySelector('.app');

    if (window.invokeNative) {
        phoneWrapper.parentNode.insertBefore(app, phoneWrapper);
        phoneWrapper.parentNode.removeChild(phoneWrapper);
        return;
    }

    document.body.style.visibility = 'visible';

    const createFrame = (children) => {
        const frame = document.createElement('div');
        frame.classList.add('phone-frame');

        const notch = document.createElement('div');
        notch.classList.add('phone-notch');

        const indicator = document.createElement('div');
        indicator.classList.add('phone-indicator');

        const phoneContent = document.createElement('div');
        phoneContent.classList.add('phone-content');
        phoneContent.appendChild(children);

        frame.appendChild(notch);
        frame.appendChild(phoneContent);
        frame.appendChild(indicator);
        return frame;
    };

    const devWrapper = document.createElement('div');
    devWrapper.classList.add('dev-wrapper');
    devWrapper.appendChild(createFrame(app));
    devWrapper.style.display = 'block';

    phoneWrapper.parentNode.insertBefore(devWrapper, phoneWrapper);
    phoneWrapper.parentNode.removeChild(phoneWrapper);
});
