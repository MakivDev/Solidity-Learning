// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract AllVariables {
    // --- ПРОСТІ ТИПИ ---
    
    // Логічна змінна (Так/Ні)
    bool public isOpen = true;
    
    // Ціле число (без мінуса) - стандарт для крипти
    uint256 public price = 100;
    
    // Адреса (гаманець)
    address public owner = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    // --- СКЛАДНІ ТИПИ ---

    // Текст
    string public message = "Hello World";

    // Масив (динамічний список чисел)
    uint256[] public luckyNumbers;

    // Мапінг (Хтось => Скільки має грошей)
    mapping(address => uint256) public balances;

    // Структура (Створюємо свій тип "Order")
    struct Order {
        address buyer;
        uint256 amount;
    }
    
    // Змінна типу "Order"
    Order public firstOrder;

    // Функція для заповнення прикладів (щоб ти бачив як записувати)
    function addData() public {
        // Додаємо в масив
        luckyNumbers.push(777);
        
        // Записуємо в мапінг
        balances[msg.sender] = 500;
        
        // Записуємо в структуру
        firstOrder = Order(msg.sender, 1000);
    }
}