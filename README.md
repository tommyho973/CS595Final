# CS595 Final Project
♻️ Choose to Reuse – Blockchain-based Container Borrow/Return System

A decentralized, trustless system for tracking reusable containers using Ethereum smart contracts, QR codes, and a user-friendly web interface.

Built with Solidity, MetaMask, ethers.js, and html5-qrcode.

---

## 📦 Overview:

Single-use packaging creates massive environmental waste, and traditional deposit-return systems struggle with tracking, refunds, and trust.

Choose to Reuse solves this using a smart contract deployed on the Ethereum Sepolia testnet. Users scan QR-coded containers to borrow or return them. Deposits are collected and refunded automatically — with no need for centralized administrators.

---

## ✨ Features:

🔐 Connect via MetaMask.

📦 Borrow containers by scanning QR codes and paying a deposit.

🔁 Return containers for an automatic refund (within a deadline).

🕓 Owner can claim expired deposits from late returns.

🧾 View real-time status of containers and deposit settings.

🔧 Admin panel to update deposit amount and borrow duration.


---

## 🏯 Architecture:

- Smart contract: Solidity (deployed on Sepolia testnet).
 
- Front-end: HTML, Tailwind CSS, JS.
 
- Blockchain integration: ethers.js
 
- QR scanning: html5-qrcode
 
- QR generation: QRcode.js

### What's stored On-chain:

- containerID → borrower, borrowTimestamp, isBorrowed

- ETH deposits and refunds

- owner-only admin controls

### What's done Off-chain:

- QR code creation & scanning

- MetaMask wallet connection (which now includes automatic admin page login!)

---

## 🚀 Installation & Run Instructions:

### 🧑‍💻 Prerequisites:

1. MetaMask browser extension.

2. Node.js/Python

3. Sepolia ETH in your wallet.

### Steps to Run:

🔹 1. Clone the Repository:

```bash
git clone https://github.com/yourusername/choose-to-reuse.git
cd choose-to-reuse
```

🔹 2. Set Your Smart Contract Address (Optional):

The program works as intended since we've already deployed the necessary smart contract on the blockchain. However, if you'd like to test admin functionality, you will need to deploy it yourself.

Deploy the Smart Contract (via Remix):
- Open https://remix.ethereum.org
- Paste in Choose2Reuse.sol
- Compile (Solidity 0.8.18+)
- Deploy using “Injected Web3” (MetaMask + Sepolia)
- Copy the contract address and paste it into the front end (read ahead)

Once the contract is deployed, copy the address and edit pretty_frontend.html by updating this line with your contract address. 

```javascript
const contractAddress = “0xYOUR_DEPLOYED_ADDRESS_HERE”;
```
Make sure contractABI includes all functions: borrowContainer, returnContainer, forfeitExpiredDeposits, etc.

NOTE: If you've deployed the contract (i.e your connected wallet address deployed the contract), you are considered the ADMIN and will have access to the admin panel.

🔹 3. Run Locally (Static Server):

You can use any static server (Live Server, http-server, etc.)

Option A – Python (recommended):

```bash
python3 -m http.server 8080
```

Option B – Node.js:

```bash
npx http-server .
```

Then open: http://localhost:8080/pretty_frontend.html

🔹 4. Deploy the Smart Contract (via Remix):
- Open https://remix.ethereum.org
- Paste in Choose2Reuse.sol
- Compile (Solidity 0.8.18+)
- Deploy using “Injected Web3” (MetaMask + Sepolia)
- Enable optimization in advanced settings
- Copy the contract address and paste it into the front end

🔹 5. Connect Wallet and Test:
- Open the app in your browser
- Click “Connect MetaMask”
- Use the Generate QR and Scanner to borrow and return containers
- Use the admin controls to collect forfeit deposits, update deposit amounts and return duration.
<img width="749" alt="Screenshot 2025-05-05 at 7 48 19 PM" src="https://github.com/user-attachments/assets/7f91d89d-1003-40f6-bf1f-5142606519e4" />
<img width="729" alt="Screenshot 2025-05-05 at 7 48 31 PM" src="https://github.com/user-attachments/assets/1dc92e89-bf3a-49d7-b427-90e4e418609e" />
<img width="895" alt="Screenshot 2025-05-05 at 7 51 11 PM" src="https://github.com/user-attachments/assets/ad3b21fc-284e-438d-8856-ff19d1b9c17b" />
<img width="676" alt="Screenshot 2025-05-05 at 7 51 36 PM" src="https://github.com/user-attachments/assets/ba317d6e-63a3-46ee-acf2-2e453d448a9e" />


---

## ⚙️ Admin Panel (improved post presentation):

The owner can:

📥 Claim deposits from expired borrows

💰 Update deposit amount (in ETH)

⏱ Change borrow duration (in days)

Compared to the demo version, upgraded version now performs wallet-based verification by checking:

```javascript
await contract.owner() === await signer.getAddress()
```
<img width="823" alt="Screenshot 2025-05-05 at 7 48 39 PM" src="https://github.com/user-attachments/assets/1f865369-6a3b-4e29-b0fb-b0a309c00be1" />
<img width="756" alt="Screenshot 2025-05-05 at 7 48 47 PM" src="https://github.com/user-attachments/assets/cd68e994-40bb-4018-9a15-e1523cb6b361" />
<img width="903" alt="Screenshot 2025-05-05 at 7 52 58 PM" src="https://github.com/user-attachments/assets/37f436f3-ee14-40d1-81d4-92e2e6d90ecf" />
<img width="726" alt="Screenshot 2025-05-05 at 7 53 09 PM" src="https://github.com/user-attachments/assets/54a00dde-a54b-42c4-82a6-5c4ae8dd44c5" />




---

## 🧪 Demo Use Case:

- User borrows a container → contract stores borrow info and deposit
- User returns the container within deadline → gets full refund
- User fails to return → after borrowDuration, owner can claim deposit
- Smart contract enforces everything — no central authority

---

## 🛠 Technologies Used:

- Solidity
- MetaMask & ethers.js
- html5-qrcode & qrcode.js
- Tailwind CSS
- Remix Ethereum IDE



