import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const fpPromise = import('@fingerprintjs/fingerprintjs')
        .then(FingerprintJS => FingerprintJS.load());

    fpPromise
        .then(fp => fp.get())
        .then(result => console.log(`Fingerprint: ${result.visitorId}`))
  }
}
