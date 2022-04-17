// SPDX-License-Identifier: MIT
pragma solidity ^0.8.11;

interface IText {
    struct Post {
        address owner;
        uint256 id;
        uint256 upVotes;
        uint256 downVotes;
        string text;
        string topic;
        string heading;
    }
}

contract Text is IText {

    address public admin;

    uint256 idCounter;

    mapping(uint256 => Post) public idPostMapping;
    Post[] public posts;

    mapping(uint256 => mapping(address => bool)) upVoters;
    mapping(uint256 => mapping(address => bool)) downVoters;

    constructor() {
        admin = msg.sender;
    }

    function createPost(
        string calldata text,
        string calldata topic,
        string calldata heading
    )
        external
    {
        Post memory newPost =
            Post(msg.sender, idCounter, 0, 0, text, topic, heading);
        posts.push(newPost);
        idPostMapping[idCounter] = newPost;
        idCounter++;
    }

    function getPost(uint256 tokenId) external view returns (Post memory) {
        return idPostMapping[tokenId];
    }

    function getPosts() external view returns (Post[] memory) {
        return posts;
    }

    function upVote(uint256 tokenId) external {
        Post memory post = idPostMapping[tokenId];
        require(!upVoters[tokenId][msg.sender]);
        post.upVotes++;
        upVoters[tokenId][msg.sender] = true;
    }

    function downVote(uint256 tokenId) external {
        Post memory post = idPostMapping[tokenId];
        require(!downVoters[tokenId][msg.sender]);
        post.downVotes++;
        downVoters[tokenId][msg.sender] = true;
    }
}