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

    struct ShipType {
        string name;
        uint256 attack;
        uint256 defense;
        uint256 health;
        uint256 energy;
        uint256 special1;
        uint256 special2;
    }

    mapping(uint256 => Ship) private ships;
    mapping(uint256 => ShipType) private shipTypes;

    modifier onlyGame() {
        require(msg.sender == game, "Only game can call this function.");
        _;
    }

    function initialize(address _game) public initializer {
        __ERC721_init("Ships", "SHIP");
        __Ownable_init();
        game = _game;
    }

    function mintShip(uint256 shipTypeId, address to) internal {
        uint256 id = totalSupply() + 1;
        Ships.Ship memory newShip = Ships.Ship(
            shipTypes[shipTypeId].name,
            shipTypes[shipTypeId].attack,
            shipTypes[shipTypeId].defense,
            shipTypes[shipTypeId].health,
            shipTypes[shipTypeId].energy,
            shipTypes[shipTypeId].special1,
            shipTypes[shipTypeId].special2,
            true
        );
        ships[id] = newShip;
        _safeMint(to, id);
    }

    function faucet(uint256[] calldata _ids) external {
        for (uint256 i = 0; i < _ids.length; i++) {
            mintShip(_ids[i], msg.sender);
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

    function setAttack(uint256 shipId, uint256 amount) external onlyGame {
        ships[shipId].attack = amount;
    }

    function setDefense(uint256 shipId, uint256 amount) external onlyGame {
        ships[shipId].defense = amount;
    }

    function getShip(uint256 id) external view returns (Ship memory) {
        return ships[id];
    }

    function setGame(address _game) external onlyOwner {
        game = _game;
    }

    function addShipTypes(
        ShipType[] calldata _shipTypes,
        uint256[] calldata _ids
    ) external onlyOwner {
        for (uint256 i = 0; i < _shipTypes.length; i++) {
            shipTypes[_ids[i]] = shipTypes[i];
        }
    }
}
