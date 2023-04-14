// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts-upgradeable/token/ERC721/extensions/ERC721EnumerableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Ships is ERC721EnumerableUpgradeable, OwnableUpgradeable {
    address public game;

    struct Ship {
        string name;
        uint256 attack;
        uint256 defense;
        uint256 health;
        uint256 energy;
        uint256 special1;
        uint256 special2;
        bool alive;
    }

    mapping(uint256 => Ship) private ships;

    modifier onlyGame() {
        require(msg.sender == game, "Only game can call this function.");
        _;
    }

    function initialize(address _game) public initializer {
        __ERC721_init("Ships", "SHIP");
        __Ownable_init();
        game = _game;
    }

    function mintShip(
        address to,
        string memory shipName,
        uint256 attack,
        uint256 defense,
        uint256 health,
        uint256 energy,
        uint256 special1,
        uint256 special2
    ) external onlyGame {
        uint256 id = totalSupply() + 1;
        ships[id] = Ship(
            shipName,
            attack,
            defense,
            health,
            energy,
            special1,
            special2,
            true
        );
        _safeMint(to, id);
    }

    function faucet(Ship[] calldata _ships) external {
        for (uint256 i = 0; i < _ships.length; i++) {
            uint256 id = totalSupply() + 1;
            ships[id] = _ships[i];
            _safeMint(msg.sender, id);
        }
    }

    function killShip(uint256 shipId) external onlyGame {
        ships[shipId].alive = false;
        ships[shipId].health = 0;
    }

    function setHealth(uint256 shipId, uint256 amount) external onlyGame {
        ships[shipId].health = amount;
    }

    function setEnergy(uint256 shipId, uint256 amount) external onlyGame {
        ships[shipId].energy = amount;
    }

    function getShip(uint256 id) external view returns (Ship memory) {
        return ships[id];
    }

    function setGame(address _game) external onlyOwner {
        game = _game;
    }
}
