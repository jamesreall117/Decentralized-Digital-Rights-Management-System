# Decentralized Digital Rights Management System

## Overview
This PR implements a blockchain-based Digital Rights Management (DRM) system using Clarity smart contracts. The system enables content creators to register their digital assets, define licensing terms, control access to their content, and track usage in a transparent and decentralized manner.

## Contracts Implemented

1. **Content Registration Contract** (`content-registration.clar`)
    - Records ownership of digital assets with metadata
    - Manages content ownership transfers
    - Controls visibility settings (public/private)
    - Stores content hashes for verification

2. **License Creation Contract** (`license-creation.clar`)
    - Defines various license types and terms
    - Manages pricing, duration, and usage limits
    - Controls commercial use and modification permissions
    - Allows updating and deactivating licenses

3. **Access Control Contract** (`access-control.clar`)
    - Manages license purchases and user permissions
    - Generates secure access keys for content
    - Handles license revocation
    - Verifies user access rights

4. **Usage Tracking Contract** (`usage-tracking.clar`)
    - Records content consumption events
    - Tracks usage statistics per user and license
    - Maintains usage history
    - Enforces usage limits for limited-use licenses

## Key Features

- **Decentralized Ownership**: Content ownership is recorded on the blockchain, providing immutable proof
- **Flexible Licensing**: Support for various license types with customizable terms
- **Transparent Transactions**: All license purchases and transfers are publicly verifiable
- **Usage Enforcement**: Smart contracts automatically enforce license terms and usage limits
- **Access Control**: Only authorized users can access content based on their purchased licenses
- **Usage Analytics**: Content creators can track how their content is being consumed

## Implementation Details

### Content Registration
- Content is registered with metadata including title, description, and content type
- A unique content hash is stored to verify content authenticity
- Content can be marked as public or private
- Ownership can be transferred to other users
- Only the content owner can update metadata or transfer ownership

### License Creation
- Licenses are linked to specific content items
- License terms include price, duration, usage limits, and permissions
- Licenses can be updated or deactivated by the creator
- Multiple license types can be created for the same content

### Access Control
- Users purchase licenses by paying the specified price
- Upon purchase, a user license record is created with expiry date and usage limits
- Access keys are generated for authenticated content access
- Content creators can revoke licenses if necessary
- Access verification checks ownership, public status, and valid licenses

### Usage Tracking
- Each content access is recorded with timestamp
- Usage history is maintained (limited to recent accesses)
- For limited-use licenses, remaining uses are decremented
- Usage statistics are available to content creators

## Testing

Each contract has a corresponding test file using Vitest:
- `content-registration.test.ts`
- `license-creation.test.ts`
- `access-control.test.ts`
- `usage-tracking.test.ts`

Tests cover the core functionality of each contract, including both successful operations and error cases. The test suite includes:

- Content registration and metadata updates
- License creation and term modifications
- License purchases and access key generation
- Usage recording and statistics tracking
- Error handling for unauthorized operations
- Edge cases like usage limits and history truncation

## Use Cases

This DRM system can be used for various digital content types:

1. **Digital Art**: Artists can sell limited licenses to their artwork
2. **Music**: Musicians can license their songs with specific usage terms
3. **E-books**: Authors can control distribution and copying of their books
4. **Software**: Developers can manage software licenses and track usage
5. **Photography**: Photographers can license their images with usage restrictions
6. **Video Content**: Creators can manage viewing rights for their videos

## Future Improvements

1. **Royalty Distribution**: Implement automatic royalty payments for content usage
2. **Collaborative Ownership**: Support for multiple creators with revenue sharing
3. **License Transfers**: Allow users to transfer or resell their licenses
4. **Subscription Models**: Support for recurring subscription payments
5. **Content Bundles**: Allow licensing of content collections or bundles
6. **Integration with Storage**: Connect with decentralized storage solutions
7. **Dispute Resolution**: Implement mechanisms for resolving licensing disputes
8. **Enhanced Analytics**: More detailed usage statistics and reporting

## Security Considerations

- All sensitive operations require proper authorization
- Content hashes ensure content integrity
- Access keys provide secure content delivery
- License terms are enforced by smart contracts
- Usage tracking prevents license abuse

## Conclusion

This Decentralized Digital Rights Management System provides a robust foundation for managing digital content rights on the blockchain. It empowers creators to maintain control over their digital assets while providing consumers with clear terms for content usage. The system's transparency, flexibility, and security make it suitable for a wide range of digital content types and licensing models.

