window.APP = {
  template: '#app_template',
  name: 'app',
  data() {
    return {
      style: CONFIG.style,
      showInput: false,
      showWindow: false,
      shouldHide: true,
      backingSuggestions: [],
      removedSuggestions: [],
      templates: CONFIG.templates,
      message: '',
      lastMessage: '',
      messages: [],
      oldMessages: [],
      oldMessagesIndex: -1,
      selectedSuggestionIndex: -1,
      tplBackups: [],
      msgTplBackups: []
    };
  },
  destroyed() {
    clearInterval(this.focusTimer);
    window.removeEventListener('message', this.listener);
  },
  mounted() {
    post('https://sinco-core/loaded', JSON.stringify({}));
    this.listener = window.addEventListener('message', (event) => {
      const item = event.data || event.detail; //'detail' is for debuging via browsers
      if (this[item.type]) {
        this[item.type](item);
      }
    });
  },
  watch: {
    messages() {
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.showWindow = true;
      this.resetShowWindowTimer();

      const messagesObj = this.$refs.messages;
      this.$nextTick(() => {
        messagesObj.scrollTop = messagesObj.scrollHeight;
      });
    },
    message(newMessage) {
      // Reset suggestion index when message changes significantly
      if (this.lastMessage !== newMessage) {
        this.selectedSuggestionIndex = -1;
        this.lastMessage = newMessage;
      }
      
      // Auto-select first suggestion when typing a command
      if (newMessage.startsWith('/') && this.suggestions.length > 0) {
        const filteredSuggestions = this.suggestions.filter(s => s.name.startsWith(newMessage));
        if (filteredSuggestions.length > 0) {
          // Only auto-select if no suggestion is currently selected
          if (this.selectedSuggestionIndex === -1) {
            this.selectedSuggestionIndex = 0;
          }
        }
      } else if (!newMessage.startsWith('/')) {
        this.selectedSuggestionIndex = -1;
      }
    },
  },
  computed: {
    suggestions() {
      return this.backingSuggestions.filter((el) => this.removedSuggestions.indexOf(el.name) <= -1);
    },
  },
  methods: {
    selectSuggestion(index) {
      this.selectedSuggestionIndex = index;
      // Update the message to match the selected suggestion and execute it
      if (this.message.startsWith('/') && this.suggestions.length > 0) {
        const filteredSuggestions = this.suggestions.filter(s => s.name.startsWith(this.message));
        if (filteredSuggestions.length > 0 && index < filteredSuggestions.length) {
          this.message = filteredSuggestions[index].name;
          // Automatically send the command
          this.$nextTick(() => {
            this.send();
          });
        }
      }
    },
    ON_SCREEN_STATE_CHANGE({ shouldHide }) {
      this.shouldHide = shouldHide;
    },
    ON_OPEN() {
      this.showInput = true;
      this.showWindow = true;
      this.selectedSuggestionIndex = -1;
      if (this.showWindowTimer) {
        clearTimeout(this.showWindowTimer);
      }
      this.focusTimer = setInterval(() => {
        if (this.$refs.input) {
          this.$refs.input.focus();
        } else {
          clearInterval(this.focusTimer);
        }
      }, 100);
    },
    ON_MESSAGE({ message }) {
      if (message.args[0] != ""){
          this.messages.push(message);
      }
    },
    ON_CLEAR() {
      this.messages = [];
      this.oldMessages = [];
      this.oldMessagesIndex = -1;
    },
    ON_SUGGESTION_ADD({ suggestion }) {
      const duplicateSuggestion = this.backingSuggestions.find(a => a.name == suggestion.name);
      if (duplicateSuggestion) {
        if(suggestion.help || suggestion.params) {
          duplicateSuggestion.help = suggestion.help || "";
          duplicateSuggestion.params = suggestion.params || [];
        }
        return;
      }
      if (!suggestion.params) {
        suggestion.params = []; //TODO Move somewhere else
      }
      this.backingSuggestions.push(suggestion);
    },
    ON_SUGGESTION_REMOVE({ name }) {
      if(this.removedSuggestions.indexOf(name) <= -1) {
        this.removedSuggestions.push(name);
      }
    },
    ON_TEMPLATE_ADD({ template }) {
      if (this.templates[template.id]) {
        this.warn(`Tried to add duplicate template '${template.id}'`)
      } else {
        this.templates[template.id] = template.html;
      }
    },
    ON_UPDATE_THEMES({ themes }) {
      this.removeThemes();

      this.setThemes(themes);
    },
    removeThemes() {
      for (let i = 0; i < document.styleSheets.length; i++) {
        const styleSheet = document.styleSheets[i];
        const node = styleSheet.ownerNode;

        if (node.getAttribute('data-theme')) {
          node.parentNode.removeChild(node);
        }
      }

      this.tplBackups.reverse();

      for (const [ elem, oldData ] of this.tplBackups) {
        elem.innerText = oldData;
      }

      this.tplBackups = [];

      this.msgTplBackups.reverse();

      for (const [ id, oldData ] of this.msgTplBackups) {
        this.templates[id] = oldData;
      }

      this.msgTplBackups = [];
    },
    setThemes(themes) {
      for (const [ id, data ] of Object.entries(themes)) {
        if (data.style) {
          const style = document.createElement('style');
          style.type = 'text/css';
          style.setAttribute('data-theme', id);
          style.appendChild(document.createTextNode(data.style));

          document.head.appendChild(style);
        }

        if (data.styleSheet) {
          const link = document.createElement('link');
          link.rel = 'stylesheet';
          link.type = 'text/css';
          link.href = data.baseUrl + data.styleSheet;
          link.setAttribute('data-theme', id);

          document.head.appendChild(link);
        }

        if (data.templates) {
          for (const [ tplId, tpl ] of Object.entries(data.templates)) {
            const elem = document.getElementById(tplId);

            if (elem) {
              this.tplBackups.push([ elem, elem.innerText ]);
              elem.innerText = tpl;
            }
          }
        }

        if (data.script) {
          const script = document.createElement('script');
          script.type = 'text/javascript';
          script.src = data.baseUrl + data.script;

          document.head.appendChild(script);
        }

        if (data.msgTemplates) {
          for (const [ tplId, tpl ] of Object.entries(data.msgTemplates)) {
            this.msgTplBackups.push([ tplId, this.templates[tplId] ]);
            this.templates[tplId] = tpl;
          }
        }
      }
    },
    warn(msg) {
      this.messages.push({
        args: [msg],
        template: '^3<b>CHAT-WARN</b>: ^0{0}',
      });
    },
    clearShowWindowTimer() {
      clearTimeout(this.showWindowTimer);
    },
    resetShowWindowTimer() {
      this.clearShowWindowTimer();
      this.showWindowTimer = setTimeout(() => {
        if (!this.showInput) {
          this.showWindow = false;
        }
      }, CONFIG.fadeTimeout);
    },
    keyUp() {
      this.resize();
    },
    keyDown(e) {
      if (e.which === 38 || e.which === 40) {
        if (this.message.startsWith('/') && this.suggestions.length > 0) {
          e.preventDefault();
          const filteredSuggestions = this.suggestions.filter(s => s.name.startsWith(this.message));
          console.log('Arrow key pressed - filtered suggestions:', filteredSuggestions);
          
          if (filteredSuggestions.length > 0) {
            // If no suggestion is selected, start with the first one
            if (this.selectedSuggestionIndex === -1) {
              this.selectedSuggestionIndex = 0;
            } else {
              if (e.which === 38) {
                // Arrow up - go to previous suggestion
                this.selectedSuggestionIndex = (this.selectedSuggestionIndex <= 0) ? filteredSuggestions.length - 1 : this.selectedSuggestionIndex - 1;
              } else {
                // Arrow down - go to next suggestion
                this.selectedSuggestionIndex = (this.selectedSuggestionIndex >= filteredSuggestions.length - 1) ? 0 : this.selectedSuggestionIndex + 1;
              }
            }
            
            this.message = filteredSuggestions[this.selectedSuggestionIndex].name;
            console.log('Arrow key navigation to suggestion:', this.selectedSuggestionIndex, filteredSuggestions[this.selectedSuggestionIndex].name);
          }
        }
      } else if (e.which === 9) { // Tab key
        // Always prevent default tab behavior when chat is active
        e.preventDefault();
        
        if (this.message.startsWith('/') && this.suggestions.length > 0) {
          const filteredSuggestions = this.suggestions.filter(s => s.name.startsWith(this.message));
          console.log('Tab pressed - filtered suggestions:', filteredSuggestions);
          
          if (filteredSuggestions.length > 0) {
            // If no suggestion is selected, start with the first one
            if (this.selectedSuggestionIndex === -1) {
              this.selectedSuggestionIndex = 0;
            } else {
              // Cycle through suggestions
              this.selectedSuggestionIndex = (this.selectedSuggestionIndex >= filteredSuggestions.length - 1) ? 0 : this.selectedSuggestionIndex + 1;
            }
            
            // Update the message with the selected suggestion
            this.message = filteredSuggestions[this.selectedSuggestionIndex].name;
            console.log('Tab cycling to suggestion:', this.selectedSuggestionIndex, filteredSuggestions[this.selectedSuggestionIndex].name);
          }
        } else {
          // If not typing a command, cycle through chat modes (original behavior)
          console.log('Tab pressed - cycling chat modes');
        }
      } else if (e.which == 33) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop - 100;
      } else if (e.which == 34) {
        var buf = document.getElementsByClassName('chat-messages')[0];
        buf.scrollTop = buf.scrollTop + 100;
      }
    },
    moveOldMessageIndex(up) {
      if (up && this.oldMessages.length > this.oldMessagesIndex + 1) {
        this.oldMessagesIndex += 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 >= 0) {
        this.oldMessagesIndex -= 1;
        this.message = this.oldMessages[this.oldMessagesIndex];
      } else if (!up && this.oldMessagesIndex - 1 === -1) {
        this.oldMessagesIndex = -1;
        this.message = '';
      }
    },
    resize() {
      const input = this.$refs.input;
      input.style.height = '5px';
      input.style.height = `${input.scrollHeight + 2}px`;
    },
    send(e) {
      if(this.message !== '') {
        let messageToSend = this.message;
        
        // If we have a selected suggestion and the message starts with /, use the selected suggestion
        if (this.selectedSuggestionIndex !== -1 && this.message.startsWith('/') && this.suggestions.length > 0) {
          const filteredSuggestions = this.suggestions.filter(s => s.name.startsWith(this.message));
          if (filteredSuggestions.length > 0 && this.selectedSuggestionIndex < filteredSuggestions.length) {
            messageToSend = filteredSuggestions[this.selectedSuggestionIndex].name;
            console.log('Using selected suggestion:', messageToSend);
          }
        }

        console.log('Sending message:', messageToSend);
        post('https://sinco-core/chatResult', JSON.stringify({
          message: messageToSend,
        }));
        this.oldMessages.unshift(this.message);
        this.oldMessagesIndex = -1;
        this.selectedSuggestionIndex = -1;
        this.hideInput();
      } else {
        this.hideInput(true);
      }
    },
    hideInput(canceled = false) {
      if (canceled) {
        post('https://sinco-core/chatResult', JSON.stringify({ canceled }));
      }
      this.selectedSuggestionIndex = -1;
      this.showInput = false;
      clearInterval(this.focusTimer);
      this.resetShowWindowTimer();
      this.message = '';
    },
  },
};
