import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static get targets() {
    return ['fingerprint'];
  }

  initialize() {
    this.generateFingerprint();
  }

  generateFingerprint() {
    const fpPromise = import('@fingerprintjs/fingerprintjs')
        .then(FingerprintJS => FingerprintJS.load());

    fpPromise
        .then(fp => fp.get())
        .then(result => this.fingerprintTarget.value = result.visitorId);
  }
}
