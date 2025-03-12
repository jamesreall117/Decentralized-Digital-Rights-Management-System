;; License Creation Contract
;; Defines terms for content usage

(define-map licenses
  { license-id: uint }
  {
    content-id: uint,
    license-type: (string-ascii 50),
    price: uint,
    duration: uint,
    max-uses: (optional uint),
    commercial-use: bool,
    modification-allowed: bool,
    creator: principal,
    creation-date: uint,
    active: bool
  }
)

(define-data-var license-id-counter uint u0)

;; Create a new license for content
(define-public (create-license
                (content-id uint)
                (license-type (string-ascii 50))
                (price uint)
                (duration uint)
                (max-uses (optional uint))
                (commercial-use bool)
                (modification-allowed bool))
  (let
    (
      (new-license-id (+ (var-get license-id-counter) u1))
    )
    (var-set license-id-counter new-license-id)
    (ok (map-set licenses
      { license-id: new-license-id }
      {
        content-id: content-id,
        license-type: license-type,
        price: price,
        duration: duration,
        max-uses: max-uses,
        commercial-use: commercial-use,
        modification-allowed: modification-allowed,
        creator: tx-sender,
        creation-date: block-height,
        active: true
      }
    ))
  )
)

;; Update license terms
(define-public (update-license
                (license-id uint)
                (price uint)
                (duration uint)
                (max-uses (optional uint))
                (commercial-use bool)
                (modification-allowed bool)
                (active bool))
  (let
    (
      (license (unwrap! (get-license license-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get creator license)) (err u403))
    (ok (map-set licenses
      { license-id: license-id }
      (merge license {
        price: price,
        duration: duration,
        max-uses: max-uses,
        commercial-use: commercial-use,
        modification-allowed: modification-allowed,
        active: active
      })
    ))
  )
)

;; Deactivate a license
(define-public (deactivate-license (license-id uint))
  (let
    (
      (license (unwrap! (get-license license-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get creator license)) (err u403))
    (ok (map-set licenses
      { license-id: license-id }
      (merge license {
        active: false
      })
    ))
  )
)

;; Get license details
(define-read-only (get-license (license-id uint))
  (map-get? licenses { license-id: license-id })
)

;; Check if license is active
(define-read-only (is-license-active (license-id uint))
  (let
    (
      (license (default-to
        {
          content-id: u0, license-type: "", price: u0, duration: u0,
          max-uses: none, commercial-use: false, modification-allowed: false,
          creator: 'SP000000000000000000002Q6VF78, creation-date: u0, active: false
        }
        (get-license license-id)))
    )
    (get active license)
  )
)

;; Get total license count
(define-read-only (get-license-count)
  (var-get license-id-counter)
)
