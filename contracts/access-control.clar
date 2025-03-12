;; Access Control Contract
;; Manages permissions for viewing or using content

(define-map user-licenses
  { user: principal, license-id: uint }
  {
    content-id: uint,
    purchase-date: uint,
    expiry-date: uint,
    uses-left: (optional uint),
    active: bool
  }
)

(define-map content-access-keys
  { content-id: uint, user: principal }
  {
    access-key: (buff 32),
    last-updated: uint
  }
)

;; Purchase a license
(define-public (purchase-license (license-id uint))
  (let
    (
      (license (unwrap! (get-license license-id) (err u404)))
      (content-id (get content-id license))
      (price (get price license))
      (duration (get duration license))
      (max-uses (get max-uses license))
      (expiry-date (+ block-height duration))
    )
    (asserts! (get active license) (err u400))

    ;; In a real implementation, we would transfer tokens here
    ;; (try! (stx-transfer? price tx-sender (get creator license)))

    (ok (map-set user-licenses
      { user: tx-sender, license-id: license-id }
      {
        content-id: content-id,
        purchase-date: block-height,
        expiry-date: expiry-date,
        uses-left: max-uses,
        active: true
      }
    ))
  )
)

;; Generate access key for content
(define-public (generate-access-key (content-id uint) (access-key (buff 32)))
  (let
    (
      (user-has-access (has-access content-id tx-sender))
    )
    (asserts! user-has-access (err u403))
    (ok (map-set content-access-keys
      { content-id: content-id, user: tx-sender }
      {
        access-key: access-key,
        last-updated: block-height
      }
    ))
  )
)

;; Revoke user license
(define-public (revoke-user-license (user principal) (license-id uint))
  (let
    (
      (user-license (unwrap! (get-user-license user license-id) (err u404)))
      (license (unwrap! (get-license license-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get creator license)) (err u403))
    (ok (map-set user-licenses
      { user: user, license-id: license-id }
      (merge user-license {
        active: false
      })
    ))
  )
)

;; Check if user has access to content
(define-read-only (has-access (content-id uint) (user principal))
  (let
    (
      (content (default-to
        {
          title: "", description: "", content-hash: 0x,
          creator: 'SP000000000000000000002Q6VF78,
          creation-date: u0, content-type: "", is-public: false
        }
        (get-content content-id)))
    )
    ;; User has access if they are the creator or the content is public
    (if (or (is-eq user (get creator content)) (get is-public content))
      true
      (has-valid-license content-id user)
    )
  )
)

;; Check if user has a valid license for content
(define-read-only (has-valid-license (content-id uint) (user principal))
  ;; In a real implementation, we would check all licenses for this content and user
  ;; This is a simplified version
  false
)

;; Get user license details
(define-read-only (get-user-license (user principal) (license-id uint))
  (map-get? user-licenses { user: user, license-id: license-id })
)

;; Get access key for content
(define-read-only (get-access-key (content-id uint) (user principal))
  (map-get? content-access-keys { content-id: content-id, user: user })
)

;; Helper functions
(define-read-only (get-license (license-id uint))
  ;; This would normally call the license-creation contract
  ;; For simplicity, we're returning a default value
  (some {
    content-id: u0,
    license-type: "",
    price: u0,
    duration: u0,
    max-uses: none,
    commercial-use: false,
    modification-allowed: false,
    creator: 'SP000000000000000000002Q6VF78,
    creation-date: u0,
    active: false
  })
)

(define-read-only (get-content (content-id uint))
  ;; This would normally call the content-registration contract
  ;; For simplicity, we're returning a default value
  (some {
    title: "",
    description: "",
    content-hash: 0x,
    creator: 'SP000000000000000000002Q6VF78,
    creation-date: u0,
    content-type: "",
    is-public: false
  })
)
