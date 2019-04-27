import React from "react";
import { Link } from "react-router-dom";

export interface UserData {
    name: string,
    img?: string,
    email?: string,
}

export interface UserAttestations {
    linkedin: boolean,
    facebook: boolean,
}

// @dev A staker can always be identified by their address, but may have approved our app to see their name and/or image.
export interface UserStaker {
    address: string,
    name?: string,
    img?: string,
}

type MyState = {
    userAddress: string;
};

export class UserProfile extends React.Component<any, MyState> {

    componentDidMount() {
        console.log(this.props.match);
        this.setState({
            userAddress: this.props.match.address
        })

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