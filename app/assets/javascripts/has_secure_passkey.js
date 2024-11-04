var __defProp = Object.defineProperty;
var __export = (target, all) => {
  for (var name in all)
    __defProp(target, name, {
      get: all[name],
      enumerable: true,
      configurable: true,
      set: (newValue) => all[name] = () => newValue
    });
};

// app/assets/javascripts/@github--webauthn-json.js
var exports__github_webauthn_json = {};
__export(exports__github_webauthn_json, {
  supported: () => {
    {
      return supported;
    }
  },
  schema: () => {
    {
      return c;
    }
  },
  get: () => {
    {
      return get;
    }
  },
  create: () => {
    {
      return create;
    }
  }
});
var base64urlToBuffer = function(e) {
  const r = "==".slice(0, (4 - e.length % 4) % 4);
  const t = e.replace(/-/g, "+").replace(/_/g, "/") + r;
  const n = atob(t);
  const i = new ArrayBuffer(n.length);
  const o = new Uint8Array(i);
  for (let e2 = 0;e2 < n.length; e2++)
    o[e2] = n.charCodeAt(e2);
  return i;
};
var bufferToBase64url = function(e) {
  const r = new Uint8Array(e);
  let t = "";
  for (const e2 of r)
    t += String.fromCharCode(e2);
  const n = btoa(t);
  const i = n.replace(/\+/g, "-").replace(/\//g, "_").replace(/=/g, "");
  return i;
};
var convert = function(t, n, i) {
  if (n === e)
    return i;
  if (n === r)
    return t(i);
  if (n instanceof Array)
    return i.map((e) => convert(t, n[0], e));
  if (n instanceof Object) {
    const e = {};
    for (const [r, o] of Object.entries(n)) {
      if (o.derive) {
        const e2 = o.derive(i);
        e2 !== undefined && (i[r] = e2);
      }
      if (r in i)
        i[r] != null ? e[r] = convert(t, o.schema, i[r]) : e[r] = null;
      else if (o.required)
        throw new Error(`Missing key: ${r}`);
    }
    return e;
  }
};
var derived = function(e, r) {
  return { required: true, schema: e, derive: r };
};
var required = function(e) {
  return { required: true, schema: e };
};
var optional = function(e) {
  return { required: false, schema: e };
};
var createRequestFromJSON = function(e) {
  return convert(base64urlToBuffer, o, e);
};
var createResponseToJSON = function(e) {
  return convert(bufferToBase64url, a, e);
};
async function create(e) {
  const r = await navigator.credentials.create(createRequestFromJSON(e));
  return createResponseToJSON(r);
}
var getRequestFromJSON = function(e) {
  return convert(base64urlToBuffer, u, e);
};
var getResponseToJSON = function(e) {
  return convert(bufferToBase64url, s, e);
};
async function get(e) {
  const r = await navigator.credentials.get(getRequestFromJSON(e));
  return getResponseToJSON(r);
}
var supported = function() {
  return !!(navigator.credentials && navigator.credentials.create && navigator.credentials.get && window.PublicKeyCredential);
};
var e = "copy";
var r = "convert";
var t = { type: required(e), id: required(r), transports: optional(e) };
var n = { appid: optional(e), appidExclude: optional(e), credProps: optional(e) };
var i = { appid: optional(e), appidExclude: optional(e), credProps: optional(e) };
var o = { publicKey: required({ rp: required(e), user: required({ id: required(r), name: required(e), displayName: required(e) }), challenge: required(r), pubKeyCredParams: required(e), timeout: optional(e), excludeCredentials: optional([t]), authenticatorSelection: optional(e), attestation: optional(e), extensions: optional(n) }), signal: optional(e) };
var a = { type: required(e), id: required(e), rawId: required(r), authenticatorAttachment: optional(e), response: required({ clientDataJSON: required(r), attestationObject: required(r), transports: derived(e, (e2) => {
  var r2;
  return ((r2 = e2.getTransports) == null ? undefined : r2.call(e2)) || [];
}) }), clientExtensionResults: derived(i, (e2) => e2.getClientExtensionResults()) };
var u = { mediation: optional(e), publicKey: required({ challenge: required(r), timeout: optional(e), rpId: optional(e), allowCredentials: optional([t]), userVerification: optional(e), extensions: optional(n) }), signal: optional(e) };
var s = { type: required(e), id: required(e), rawId: required(r), authenticatorAttachment: optional(e), response: required({ clientDataJSON: required(r), authenticatorData: required(r), signature: required(r), userHandle: required(r) }), clientExtensionResults: derived(i, (e2) => e2.getClientExtensionResults()) };
var c = { credentialCreationOptions: o, publicKeyCredentialWithAttestation: a, credentialRequestOptions: u, publicKeyCredentialWithAssertion: s };

// app/assets/javascripts/@rails--request.js
var getCookie = function(t2) {
  const e2 = document.cookie ? document.cookie.split("; ") : [];
  const n2 = `${encodeURIComponent(t2)}=`;
  const s2 = e2.find((t3) => t3.startsWith(n2));
  if (s2) {
    const t3 = s2.split("=").slice(1).join("=");
    if (t3)
      return decodeURIComponent(t3);
  }
};
var compact = function(t2) {
  const e2 = {};
  for (const n2 in t2) {
    const s2 = t2[n2];
    s2 !== undefined && (e2[n2] = s2);
  }
  return e2;
};
var metaContent = function(t2) {
  const e2 = document.head.querySelector(`meta[name="${t2}"]`);
  return e2 && e2.content;
};
var stringEntriesFromFormData = function(t2) {
  return [...t2].reduce((t3, [e2, n2]) => t3.concat(typeof n2 === "string" ? [[e2, n2]] : []), []);
};
var mergeEntries = function(t2, e2) {
  for (const [n2, s2] of e2)
    if (!(s2 instanceof window.File))
      if (t2.has(n2) && !n2.includes("[]")) {
        t2.delete(n2);
        t2.set(n2, s2);
      } else
        t2.append(n2, s2);
};
async function post(t2, e2) {
  const n2 = new FetchRequest("post", t2, e2);
  return n2.perform();
}
class FetchResponse {
  constructor(t2) {
    this.response = t2;
  }
  get statusCode() {
    return this.response.status;
  }
  get redirected() {
    return this.response.redirected;
  }
  get ok() {
    return this.response.ok;
  }
  get unauthenticated() {
    return this.statusCode === 401;
  }
  get unprocessableEntity() {
    return this.statusCode === 422;
  }
  get authenticationURL() {
    return this.response.headers.get("WWW-Authenticate");
  }
  get contentType() {
    const t2 = this.response.headers.get("Content-Type") || "";
    return t2.replace(/;.*$/, "");
  }
  get headers() {
    return this.response.headers;
  }
  get html() {
    return this.contentType.match(/^(application|text)\/(html|xhtml\+xml)$/) ? this.text : Promise.reject(new Error(`Expected an HTML response but got "${this.contentType}" instead`));
  }
  get json() {
    return this.contentType.match(/^application\/.*json$/) ? this.responseJson || (this.responseJson = this.response.json()) : Promise.reject(new Error(`Expected a JSON response but got "${this.contentType}" instead`));
  }
  get text() {
    return this.responseText || (this.responseText = this.response.text());
  }
  get isTurboStream() {
    return this.contentType.match(/^text\/vnd\.turbo-stream\.html/);
  }
  get isScript() {
    return this.contentType.match(/\b(?:java|ecma)script\b/);
  }
  async renderTurboStream() {
    if (!this.isTurboStream)
      return Promise.reject(new Error(`Expected a Turbo Stream response but got "${this.contentType}" instead`));
    window.Turbo ? await window.Turbo.renderStreamMessage(await this.text) : console.warn("You must set `window.Turbo = Turbo` to automatically process Turbo Stream events with request.js");
  }
  async activeScript() {
    if (!this.isScript)
      return Promise.reject(new Error(`Expected a Script response but got "${this.contentType}" instead`));
    {
      const t2 = document.createElement("script");
      const e2 = document.querySelector("meta[name=csp-nonce]");
      const n2 = e2 && e2.content;
      n2 && t2.setAttribute("nonce", n2);
      t2.innerHTML = await this.text;
      document.body.appendChild(t2);
    }
  }
}

class RequestInterceptor {
  static register(t2) {
    this.interceptor = t2;
  }
  static get() {
    return this.interceptor;
  }
  static reset() {
    this.interceptor = undefined;
  }
}

class FetchRequest {
  constructor(t2, e2, n2 = {}) {
    this.method = t2;
    this.options = n2;
    this.originalUrl = e2.toString();
  }
  async perform() {
    try {
      const t3 = RequestInterceptor.get();
      t3 && await t3(this);
    } catch (t3) {
      console.error(t3);
    }
    const t2 = this.responseKind === "turbo-stream" && window.Turbo ? window.Turbo.fetch : window.fetch;
    const e2 = new FetchResponse(await t2(this.url, this.fetchOptions));
    if (e2.unauthenticated && e2.authenticationURL)
      return Promise.reject(window.location.href = e2.authenticationURL);
    e2.isScript && await e2.activeScript();
    const n2 = e2.ok || e2.unprocessableEntity;
    n2 && e2.isTurboStream && await e2.renderTurboStream();
    return e2;
  }
  addHeader(t2, e2) {
    const n2 = this.additionalHeaders;
    n2[t2] = e2;
    this.options.headers = n2;
  }
  sameHostname() {
    if (!this.originalUrl.startsWith("http:"))
      return true;
    try {
      return new URL(this.originalUrl).hostname === window.location.hostname;
    } catch (t2) {
      return true;
    }
  }
  get fetchOptions() {
    return { method: this.method.toUpperCase(), headers: this.headers, body: this.formattedBody, signal: this.signal, credentials: this.credentials, redirect: this.redirect };
  }
  get headers() {
    const t2 = { "X-Requested-With": "XMLHttpRequest", "Content-Type": this.contentType, Accept: this.accept };
    this.sameHostname() && (t2["X-CSRF-Token"] = this.csrfToken);
    return compact(Object.assign(t2, this.additionalHeaders));
  }
  get csrfToken() {
    return getCookie(metaContent("csrf-param")) || metaContent("csrf-token");
  }
  get contentType() {
    return this.options.contentType ? this.options.contentType : this.body == null || this.body instanceof window.FormData ? undefined : this.body instanceof window.File ? this.body.type : "application/json";
  }
  get accept() {
    switch (this.responseKind) {
      case "html":
        return "text/html, application/xhtml+xml";
      case "turbo-stream":
        return "text/vnd.turbo-stream.html, text/html, application/xhtml+xml";
      case "json":
        return "application/json, application/vnd.api+json";
      case "script":
        return "text/javascript, application/javascript";
      default:
        return "*/*";
    }
  }
  get body() {
    return this.options.body;
  }
  get query() {
    const t2 = (this.originalUrl.split("?")[1] || "").split("#")[0];
    const e2 = new URLSearchParams(t2);
    let n2 = this.options.query;
    n2 = n2 instanceof window.FormData ? stringEntriesFromFormData(n2) : n2 instanceof window.URLSearchParams ? n2.entries() : Object.entries(n2 || {});
    mergeEntries(e2, n2);
    const s2 = e2.toString();
    return s2.length > 0 ? `?${s2}` : "";
  }
  get url() {
    return this.originalUrl.split("?")[0].split("#")[0] + this.query;
  }
  get responseKind() {
    return this.options.responseKind || "html";
  }
  get signal() {
    return this.options.signal;
  }
  get redirect() {
    return this.options.redirect || "follow";
  }
  get credentials() {
    return this.options.credentials || "same-origin";
  }
  get additionalHeaders() {
    return this.options.headers || {};
  }
  get formattedBody() {
    const t2 = Object.prototype.toString.call(this.body) === "[object String]";
    const e2 = this.headers["Content-Type"] === "application/json";
    return e2 && !t2 ? JSON.stringify(this.body) : this.body;
  }
}

// app/assets/javascripts/components/web_authn.js
class WebAuthn extends HTMLElement {
  static observedAttributes = ["action", "callback", "options"];
  constructor() {
    super();
  }
  connectedCallback() {
    this.progressBar = Turbo.navigator.delegate.adapter.progressBar;
    this.style.display = "none";
    this.setAttribute("data-turbo-temporary", 1);
    this.setAttribute("data-turbo-track", "reload");
    this.run();
  }
  run() {
    window.WebAuthn = WebAuthn;
    window.webauthn_options = this.options;
    console.log("hi");
    exports__github_webauthn_json[this.action](this.options).then(async (credential) => {
      this.showProgress();
      const { response, redirected } = await post(this.callback, {
        responseKind: "turbo-stream",
        body: JSON.stringify(Object.assign(credential, { webauthn_message: this.message }))
      });
      this.hideProgress();
      if (response.ok && redirected) {
        const responseHTML = await response.text();
        const options = {
          action: "advance",
          shouldCacheSnapshot: false,
          response: { statusCode: response.status, responseHTML, redirected }
        };
        Turbo.navigator.proposeVisit(new URL(response.url), options);
      }
    }).catch((error) => {
      this.onError(error);
    });
  }
  showProgress() {
    this.progressBar.setValue(0);
    this.progressBar.show();
  }
  hideProgress() {
    this.progressBar.setValue(1);
    this.progressBar.hide();
  }
  onError(error) {
    let event;
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
    return this.getAttribute("action");
  }
  get callback() {
    return this.getAttribute("callback");
  }
  get options() {
    return JSON.parse(this.getAttribute("options"));
  }
  get message() {
    return this.getAttribute("message");
  }
}

// app/assets/javascripts/components/has_secure_passkey.js
customElements.define("web-authn", WebAuthn);
