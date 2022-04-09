const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const tokenContract = await ethers.getContractFactory("HVQToken");
  const contract = await tokenContract.deploy();

  await contract.deployed();

  console.log("Contract address :", contract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
