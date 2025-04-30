# CS595Final
♻️ Choose to Reuse – Blockchain-based Container Borrow/Return System

A decentralized, trustless system for tracking reusable containers using Ethereum smart contracts, QR codes, and a user-friendly web interface.

Built with Solidity, MetaMask, ethers.js, and html5-qrcode.

---

📦 Overview:

Single-use packaging creates massive environmental waste, and traditional deposit-return systems struggle with tracking, refunds, and trust.

Choose to Reuse solves this using a smart contract deployed on the Ethereum Sepolia testnet. Users scan QR-coded containers to borrow or return them. Deposits are collected and refunded automatically — with no need for centralized administrators.

---

✨ Features:

🔐 Connect via MetaMask.

📦 Borrow containers by scanning QR codes and paying a deposit.

🔁 Return containers for an automatic refund (within a deadline).

🕓 Owner can claim expired deposits from late returns.

🧾 View real-time status of containers and deposit settings.

🔧 Admin panel to update deposit amount and borrow duration.


---

🏛 Architecture:

Smart contract: Solidity (deployed on Sepolia testnet).
 
Front-end: HTML, Tailwind CSS, JS.
 
Blockchain integration: ethers.js
 
QR scanning: html5-qrcode
 
QR generation: qrcode.js

On-chain:

containerID → borrower, borrowTimestamp, isBorrowed

ETH deposits and refunds

owner-only admin controls

Off-chain:

QR code creation & scanning

MetaMask wallet connection

Admin login UI (username/password or wallet-based)

---

🚀 Installation & Run Instructions:

🧑‍💻 Prerequisites:

1. MetaMask browser extension.

2. Node.js/Python

3. Sepolia ETH in your wallet.

🔹 1. Clone the Repository:

bash
git clone https://github.com/yourusername/choose-to-reuse.git
cd choose-to-reuse

🔹 2. Set Your Smart Contract Address:

Edit pretty_frontend.html and update this line:

javascript
const contractAddress = “0xYOUR_DEPLOYED_ADDRESS_HERE”;

Make sure contractABI includes all functions: borrowContainer, returnContainer, forfeitExpiredDeposits, etc.

🔹 3. Run Locally (Static Server):

You can use any static server (Live Server, http-server, etc.)

Option A – Python:

bash
python3 -m http.server 8080

Option B – Node.js:

bash
npx http-server .

Then open: http://localhost:8080/pretty_frontend.html

🔹 4. Deploy the Smart Contract (via Remix):
	•	Open https://remix.ethereum.org
	•	Paste in Choose2Reuse.sol
	•	Compile (Solidity 0.8.18+)
	•	Deploy using “Injected Web3” (MetaMask + Sepolia)
	•	Copy the contract address and paste it into the front end

🔹 5. Connect Wallet and Test:
	•	Open the app in your browser
	•	Click “Connect MetaMask”
	•	Use the Generate QR and Scanner to borrow and return containers
	•	Try logging in as “terrier / terrier123” to access admin controls

---

⚙️ Admin Panel

The owner (username: terrier, password: terrier123) can:
	•	📥 Claim deposits from expired borrows
	•	💰 Update deposit amount (in ETH)
	•	⏱ Change borrow duration (in days)

Alternatively, upgrade to wallet-based verification by checking:

javascript
await contract.owner() === await signer.getAddress()

---

🧪 Demo Use Cases
	1.	User borrows a container → contract stores borrow info and deposit
	2.	User returns the container within deadline → gets full refund
	3.	User fails to return → after borrowDuration, owner can claim deposit
	4.	Smart contract enforces everything — no central authority

---

🛠 Technologies Used
	•	Solidity
	•	MetaMask & ethers.js
	•	html5-qrcode & qrcode.js
	•	Tailwind CSS
	•	Remix Ethereum IDE



