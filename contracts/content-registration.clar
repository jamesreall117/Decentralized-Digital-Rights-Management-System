;; Content Registration Contract
;; Records ownership of digital assets

(define-map content-assets
  { content-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    content-hash: (buff 32),
    creator: principal,
    creation-date: uint,
    content-type: (string-ascii 50),
    is-public: bool
  }
)

(define-data-var content-id-counter uint u0)

;; Register a new digital asset
(define-public (register-content
                (title (string-ascii 100))
                (description (string-ascii 500))
                (content-hash (buff 32))
                (content-type (string-ascii 50))
                (is-public bool))
  (let
    (
      (new-content-id (+ (var-get content-id-counter) u1))
    )
    (var-set content-id-counter new-content-id)
    (ok (map-set content-assets
      { content-id: new-content-id }
      {
        title: title,
        description: description,
        content-hash: content-hash,
        creator: tx-sender,
        creation-date: block-height,
        content-type: content-type,
        is-public: is-public
      }
    ))
  )
)

;; Update content metadata
(define-public (update-content-metadata
                (content-id uint)
                (title (string-ascii 100))
                (description (string-ascii 500))
                (is-public bool))
  (let
    (
      (content (unwrap! (get-content content-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get creator content)) (err u403))
    (ok (map-set content-assets
      { content-id: content-id }
      (merge content {
        title: title,
        description: description,
        is-public: is-public
      })
    ))
  )
)

;; Transfer content ownership
(define-public (transfer-content-ownership (content-id uint) (new-owner principal))
  (let
    (
      (content (unwrap! (get-content content-id) (err u404)))
    )
    (asserts! (is-eq tx-sender (get creator content)) (err u403))
    (ok (map-set content-assets
      { content-id: content-id }
      (merge content {
        creator: new-owner
      })
    ))
  )
)

;; Get content details
(define-read-only (get-content (content-id uint))
  (map-get? content-assets { content-id: content-id })
)

;; Check if user is content owner
(define-read-only (is-content-owner (content-id uint) (user principal))
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
    (is-eq user (get creator content))
  )
)

;; Get total content count
(define-read-only (get-content-count)
  (var-get content-id-counter)
)
