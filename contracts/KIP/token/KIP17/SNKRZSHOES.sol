// SPDX-License-Identifier: MIT
// Klaytn Contract Library v1.0.0 (KIP/token/KIP17/KIP17.sol)

pragma solidity ^0.8.0;

import "./KIP17.sol";
import "./extensions/KIP17Burnable.sol";
import "./extensions/KIP17Enumerable.sol";
import "./extensions/KIP17MetadataMintable.sol";
// import "./extensions/KIP17Mintable.sol";
import "./extensions/KIP17Pausable.sol";
import "./extensions/KIP17URIStorage.sol";
import "./extensions/KIP17BurnablePause.sol";
import "./extensions/KIP17Mintable.sol";

import "../../../utils/Strings.sol";

// import "../access/roles/MinterRole.sol";



contract SNKRZSHOES is KIP17Burnable, KIP17Enumerable, KIP17MetadataMintable, KIP17BurnablePause {
// contract SNKRZSHOES is KIP17Burnable, KIP17Enumerable, KIP17BurnablePause, KIP17Mintable {
    using Strings for uint256;

    // 특정 블록 넘버 전까지 막기
    mapping(uint256 => uint256) private _locked;

    constructor (string memory name, string memory symbol) public KIP17(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        addMinter(_msgSender());
        addPauser(_msgSender()); 
    }

    // function supportsInterface(bytes4 interfaceId) public view virtual override(KIP17Burnable, KIP17Enumerable, KIP17MetadataMintable, KIP17BurnablePause) returns (bool) {
    //     return
    //         KIP17Burnable.supportsInterface(interfaceId) ||
    //         KIP17Enumerable.supportsInterface(interfaceId) ||
    //         KIP17MetadataMintable.supportsInterface(interfaceId) ||
    //         KIP17BurnablePause.supportsInterface(interfaceId);
    //         // KIP17URIStorage.supportsInterface(interfaceId);
    // }

    function supportsInterface(bytes4 interfaceId) public view virtual override(KIP17Burnable, KIP17Enumerable, KIP17BurnablePause, KIP17MetadataMintable) returns (bool) {
        return
            KIP17Burnable.supportsInterface(interfaceId) ||
            KIP17Enumerable.supportsInterface(interfaceId) ||
            KIP17MetadataMintable.supportsInterface(interfaceId) ||
            KIP17BurnablePause.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(KIP17, KIP17Enumerable, KIP17BurnablePause) {
        super._beforeTokenTransfer(from, to, tokenId);
        require(block.number >= _locked[tokenId], "SNKRZ: you are not allowed to transfer for designated time");
        
        
        // do stuff before every transfer
        // e.g. check that vote (other than when minted) 
        // being transferred to registered candidate
    }

    function _burn(uint256 tokenId) internal virtual override(KIP17, KIP17URIStorage) {
        KIP17._burn(tokenId);
    }

    function tokenURI(uint256 tokenId) public view virtual override(KIP17, KIP17URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
        // string memory baseURI = _baseURI();
        // return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    function callsetMetaData( string memory name, string memory symbol ) public onlyRole(MINTER_ROLE) {
        KIP17._setMetaData(name, symbol);
    }

    function setlocked( uint256 tokenId, uint256 blockNum ) public onlyRole(MINTER_ROLE) {
        _locked[tokenId] = blockNum;
    }

    function safeTransferFrom( address from, address to, uint256 tokenId ) public virtual override {
        KIP17.safeTransferFrom(from, to, tokenId);
    }

    function callchangeTokenURI( uint256 tokenId, string memory _tokenURI ) public onlyRole(MINTER_ROLE) {
        KIP17URIStorage._changeTokenURI(tokenId, _tokenURI);
    }

    // function setApprovalForAll(address operator, bool approved) public virtual override {
    //     _setApprovalForAll(_msgSender(), operator, approved);

    //     uint256 balance = KIP17.balanceOf(_msgSender());
    //     uint256 i =0 ;
    //     while ( i <  )
    //     if (block.number < _locked[tokenId]) {
    //         revert();
    //     }
    // }
    
    // function _baseURI() internal view virtual override(KIP17) returns (string memory) {
    //     return "https://born.by-syl.com/json/";
    // }

    // function getbaseURI() public view returns (string memory) {
    //     return _baseURI();
    // }

}