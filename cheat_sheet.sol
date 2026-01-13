// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

/**
 * @title Solidity Ultimate Cheat Sheet for Beginners
 * @dev Цей контракт містить усі основні правила синтаксису та типів даних.
 */
contract SolidityCheatSheet {

    // --- 1. ENUM (ПЕРЕРАХУВАННЯ) ---
    // Використовуй для станів (0, 1, 2...). Дуже економить газ!
    enum Status { 
        Pending,   // 0
        Active,    // 1
        Closed,    // 2
        Canceled   // 3
    }
    Status public currentStatus = Status.Pending;

    // --- 2. СТРУКТУРИ ТА МАПІНГИ ---
    struct User {
        string name;
        uint256 age;
        bool isRegistered;
    }

    // Mapping: Ключ (address) => Значення (User struct)
    mapping(address => User) public users;

    // --- 3. ЗМІННІ СТАНУ (STORAGE - Фундамент) ---
    // Тип + Видимість + Назва = Значення;
    address public owner;             // Адреса гаманця
    uint256 public constant MAX_SUPPLY = 1000000; // Constant - не можна змінити
    bool public paused = false;        // Логічне значення
    string public contractNote;        // Текст

    // --- 4. КОНСТРУКТОР ---
    // Виконується один раз при деплої контракту
    constructor() {
        owner = msg.sender; // Той, хто деплоїть - власник
    }

    // --- 5. ФУНКЦІЇ: ВИДИМІСТЬ ТА ТИПИ ---

    // PAYABLE: Дозволяє приймати ETH. msg.value - сума в Wei
    function deposit() public payable {
        require(msg.value > 0, "Send some ETH");
    }

    // VIEW: Тільки читає Storage. Безкоштовно ззовні.
    function getBalance() public view returns (uint256) {
        return address(this).balance; // Баланс цього контракту
    }

    // PURE: Навіть не читає Storage (просто калькулятор). Безкоштовно.
    function add(uint256 a, uint256 b) public pure returns (uint256) {
        return a + b; 
    }

    // --- 6. DATA LOCATIONS (STORAGE, MEMORY, CALLDATA) ---

    // CALLDATA: Для вхідних string/array. Найдешевше (тільки читання).
    function updateNote(string calldata _newNote) external {
        contractNote = _newNote; // Копіюємо з calldata в storage
    }

    // MEMORY: Для тимчасових даних всередині функції.
    function getShortNote() public view returns (string memory) {
        string memory temp = contractNote; // Тимчасова копія
        return temp;
    }

    // --- 7. СИНТАКСИЧНА ШПАРГАЛКА (ПРАВИЛА ДУЖОК) ---
    function syntaxExample(string calldata _name, uint256 _age) public {
        // [ ] Квадратні = ПОШУК (в мапінгу)
        // . Крапка = ДЕТАЛЬ (властивість структури)
        // ( ) Круглі = ДІЯ (створення об'єкту)
        
        users[msg.sender] = User(_name, _age, true);
        
        // Перевірка умови: ( ) для умови, { } для коду
        if (users[msg.sender].age >= 18) {
            currentStatus = Status.Active; // Використання Enum
        }
    }

    // --- 8. ВИВЕДЕННЯ ГРОШЕЙ (TRANSFER) ---
    function withdraw() public {
        require(msg.sender == owner, "Not an owner!");
        
        // Передаємо весь баланс контракту власнику
        payable(owner).transfer(address(this).balance);
    }
}