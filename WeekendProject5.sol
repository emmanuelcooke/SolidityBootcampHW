import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import { Lottery, LotteryToken } from './contracts'; // Import the contracts

const LotteryApp = () => {
  const [provider, setProvider] = useState(null);
  const [lotteryContract, setLotteryContract] = useState(null);
  const [tokenContract, setTokenContract] = useState(null);
  const [accounts, setAccounts] = useState([]);
  const [ticketPrice, setTicketPrice] = useState(0);
  const [balance, setBalance] = useState(0);
  const [isWinner, setIsWinner] = useState(false);

  // Connect to the Ethereum network on component mount
  useEffect(() => {
    connectToNetwork();
  }, []);

  // Connect to the Ethereum network and set up contracts
  const connectToNetwork = async () => {
    // Connect to an Ethereum provider (e.g., MetaMask)
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    setProvider(provider);

    // Retrieve the user's accounts
    const accounts = await provider.listAccounts();
    setAccounts(accounts);

    // Set up the contracts
    const lotteryContract = new ethers.Contract(Lottery.address, Lottery.abi, provider.getSigner());
    setLotteryContract(lotteryContract);

    const tokenContract = new ethers.Contract(LotteryToken.address, LotteryToken.abi, provider.getSigner());
    setTokenContract(tokenContract);

    // Fetch initial data
    await fetchLotteryData();
  };

  const fetchLotteryData = async () => {
    // Fetch ticket price
    const price = await lotteryContract.ticketPrice();
    setTicketPrice(price);

    // Fetch balance
    const balance = await tokenContract.balanceOf(Lottery.address);
    setBalance(balance);

    // Fetch winner status
    const winner = await lotteryContract.isWinner(accounts[0]);
    setIsWinner(winner);
  };

  const purchaseTicket = async () => {
    // Send a transaction to purchase a ticket
    const transaction = await lotteryContract.purchaseTicket({ value: ticketPrice });
    await transaction.wait();

    // Refresh the lottery data if the ticket purchase is successful
    await fetchLotteryData();
  };

  return (
    <div>
      <h1>Lottery dApp</h1>
      <p>Current ticket price: {ethers.utils.formatEther(ticketPrice)} ETH</p>
      <p>Current balance: {ethers.utils.formatEther(balance)} ETH</p>
      <p>Is winner: {isWinner ? 'Yes' : 'No'}</p>
      <button onClick={purchaseTicket}>Purchase Ticket</button>
    </div>
  );
};

export default LotteryApp;
