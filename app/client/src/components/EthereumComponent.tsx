import React from "react";
import web3Init from '../utils/web3Init';

export class EthereumComponent extends React.Component <{}, {}>{
    state: {
        web3: null
    }

    private  async loadWeb3 () {
        const web3 = await web3Init() ;
        this.setState ({
            web3
        });
    }

    componentWillMount() {
        // metaMask listener
        window.addEventListener('load', async () => {
          await this.loadWeb3();
        });
    }
}