// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    struct Campaign{
        address owner;
        string title;
        string description;
        uint target;
        uint deadline;
        uint amount;
        string image;
        address[] donaters;
        uint[] donations;
    }

    mapping(uint => Campaign) public campaigns;
    uint public numberOfCampaigns = 0;

    function createCampaign(address _owner, string memory _title,string memory _description,uint256 _target,uint256 _deadline,string memory _image) public returns(uint256) {
        Campaign storage newCampaign = campaigns[numberOfCampaigns];
        require(newCampaign.deadline < block.timestamp, "Campaign deadline has passed");
        require(newCampaign.owner != address(0), "Campaign owner cannot be 0 address");

        newCampaign.owner = _owner;
        newCampaign.description = _description;
        newCampaign.target = _target;
        newCampaign.deadline = _deadline;
        newCampaign.image = _image;
        newCampaign.title = _title;
        newCampaign.amount = 0;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_id];
        campaign.donaters.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");
        
        if(sent){
            campaign.amount += amount;
        }
    }

    function getDonators(uint256 _id) view public returns(address[] memory,uint[] memory) {
        return (campaigns[_id].donaters,campaigns[_id].donations);
    }

    function getCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory _campaigns = new Campaign[](numberOfCampaigns);
        for (uint i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            _campaigns[i] = item;
        }
        return _campaigns;
    }
}