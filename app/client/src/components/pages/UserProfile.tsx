import React from "react";
import { Link } from "react-router-dom";

import "bootstrap/dist/css/bootstrap.min.css";
import "shards-ui/dist/css/shards.min.css"

import { Provider, Heading, Subhead } from 'rebass'
import {
    Hero, CallToAction, ScrollDownIndicator
} from 'react-landing-page'

type MyState = {
    userAddress: string;
};

export class UserProfile extends React.Component<any, MyState> {

    componentDidMount() {
        console.log(this.props);
        console.log(this.props.match);
        const userAddress = this.props.match.params.address;

        /* Get the user account data from TheGraph
            - The user previously set up bloom stuff w/ us. Unfortunately they can't just share all future data.
            - Bloom Attestations that were shared with the web app, or can we get all of them?? The user has to share them.  
            - User Staking can be loaded from web3 directly. If it fails, we'll spend a day adding TheGraph
            - We can get hardcoded data from the user on our platform when they sign up. This includes 
        */ 
        // fetch(`https://api.twitter.com/user/${handle}`)
        //     .then((user) => {
        //         this.setState(() => ({ user }))
        //     })


            // Fetch our web app data
            // Get user staking
    }

    render() {
        return (<div>
            <a>a</a>
        </div>);
    }
}