import Web3 from 'web3';
declare global {
    interface Window {
        ethereum: any;
        web3: any;
    }
};

let _web3;

async function initWeb3 () {
    if (_web3) {
        return _web3;
    } else {
        if (window.ethereum) {
            //Use EIP-1102 compatible provider
            _web3 = new Web3(window.ethereum);
            await window.ethereum.enable();
        } else if (typeof window.web3 !== 'undefined') {
            //Use original Web3 provider
            _web3 = new Web3(Web3.givenProvider || window.web3.currentProvider);
        } else {
            console.log('No web3? You should consider trying MetaMask!')
            // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
            // @ts-ignore
            _web3 = new Web3(new Web3.providers.HttpProvider("https://mainnet.infura.io/v3/60ab76e16df54c808e50a79975b4779f"));
        }
    }
}

export default initWeb3;