import { post } from "@rails/request.js"

export default class WebAuthn extends HTMLElement {
  static observedAttributes = ["action", "callback", "options"];

  constructor() {
    super();
  }

  connectedCallback() {
    this.progressBar = Turbo.navigator.delegate.adapter.progressBar
    this.setAttribute("data-turbo-temporary", 1)
    this.setAttribute("data-turbo-track", "reload")
    this.run()
  }

  run() {
    navigator.credentials[this.action]({publicKey: this.publicKey}).
      then(async (credential) => {
        this.showProgress()

        const { response, redirected } = await post(this.callback, {
          responseKind: "turbo-stream",
          body: JSON.stringify(Object.assign(credential.toJSON(), { webauthn_message: this.message }))
        })

        this.hideProgress()

        if (response.ok && redirected) {
          const responseHTML = await response.text()
          const options = { action: "advance", shouldCacheSnapshot: false,
            response: { statusCode: response.status, responseHTML, redirected } }
            Turbo.navigator.proposeVisit(new URL(response.url), options)
        }
      }).catch((error) => {
        console.error(error)
        this.onError(error)
      })
  }

  showProgress() {
    this.progressBar.setValue(0)
    this.progressBar.show()
  }

  hideProgress() {
    this.progressBar.setValue(1)
    this.progressBar.hide()
  }

  onError(error) {
    let event

    if (error.code === 0 && error.name === "NotAllowedError") {
      event = new CustomEvent("web-authn-error", { bubbles: true, detail: "That didn't work. Either it was cancelled or took too long. Please try again." });
    } else if (error.code === 11 && error.name === "InvalidStateError") {
      event = new CustomEvent("web-authn-error", { bubbles: true, detail: "We couldn't add that security key. Looks like you may have already registered it." });
    } else {
      event = new CustomEvent("web-authn-error", { bubbles: true, detail: error.message });
    }

    this.dispatchEvent(event);
  }

  get action() {
    return this.getAttribute('action');
  }

  get callback() {
    return this.getAttribute('callback');
  }

  get options() {
    return JSON.parse(this.getAttribute('options'));
  }

  get message() {
    return this.getAttribute('message');
  }

  get publicKey() {
    if (this.action === "create") {
      return PublicKeyCredential.parseCreationOptionsFromJSON(this.options);
    } else {
      return PublicKeyCredential.parseRequestOptionsFromJSON(this.options);
    }
  }
}
