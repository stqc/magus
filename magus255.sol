// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.1/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.7.1/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts@4.7.1/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.7.1/token/ERC721/extensions/ERC721Royalty.sol";
import "@openzeppelin/contracts@4.7.1/security/Pausable.sol";
import "@openzeppelin/contracts@4.7.1/access/Ownable.sol";
import "@openzeppelin/contracts@4.7.1/utils/Strings.sol";

contract Magus255 is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Royalty, Pausable, Ownable {
    
    address public own;
    uint256 public price = 0.01 ether;
    string base="https://ipfs.io/ipfs/Qmdhd3w78Dcp9n9mLwdgALeD5EhhvMMcAeBBAjpw1ZvwCZ";
    mapping(address=>bool) public isWhitelisted;
    bool public whitelistTime=true;
    uint256 [] items;

    constructor() ERC721("Magus255", "MAG255") {
        own =msg.sender;
    }
    
    


    modifier whitelistEnabled{
        if(whitelistTime){
            price = 0.005 ether;
            require(isWhitelisted[msg.sender],"you are not whitelisted");
        }
        _;

    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function addToWhiteList(address [] memory l) external onlyOwner{
        for(uint i =0; i<l.length; i++){
            isWhitelisted[l[i]]=true;
        }
    }

    function addToItems(uint256 [] memory ites) external onlyOwner{
      for(uint256 i=0; i <ites.length; i++){
            items.push(ites[i]);
        }
    }

    function mint(uint256 amount) external payable whenNotPaused whitelistEnabled{
        require(items.length>0,"The collection has been completely minted");
        uint256 val = amount * price;
        require(val == msg.value,"incorrect amount sent");
        (bool success,) = own.call{value:val}("");
        require(success,"transfer failed");
        for(uint i =0; i<amount; i++ ){
            uint256 idToMint = chooseId();
            _safeMint(msg.sender,idToMint);
            string memory id = Strings.toString(items[idToMint]);
            _setTokenURI(idToMint,string.concat("/",id,".json"));
            items[idToMint] = items[items.length-1];
            items.pop();
            }
    }

    function disableWhitelist() external onlyOwner{
        whitelistTime=false;
    }

    function showNFTsLeft() external view returns (uint256){
        return items.length;
    }

    receive() external  payable{}

    function chooseId() internal view returns(uint256){
            return (block.timestamp**7+255)%items.length;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return base;
    }

    function setBaseURI(string memory uri) external onlyOwner{
        base = uri;
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        whenNotPaused
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // The following functions are overrides required by Solidity.
    

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage,ERC721Royalty) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable,ERC721Royalty)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    //set default Royaltyfee for all tokens
    function setRoyaltyForAll(uint96 fee) external onlyOwner{
        _setDefaultRoyalty(msg.sender,fee);
    }

    

}
