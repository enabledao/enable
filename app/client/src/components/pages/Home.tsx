import React from "react";
import { Link } from "react-router-dom";

import "bootstrap/dist/css/bootstrap.min.css";
import "shards-ui/dist/css/shards.min.css"

import { Provider, Heading, Subhead } from 'rebass'
import {
  Hero, CallToAction, ScrollDownIndicator
} from 'react-landing-page'

type MyState = {};

export class Home extends React.Component<{}, MyState> {
  render() {
    return (
        <Provider>
          <Hero
            color="black"
            bg="white"
            backgroundImage="https://source.unsplash.com/jxaj-UrzQbc/1600x900"
          >
            <Heading>Enable</Heading>
            <Subhead>Borderless peer-to-peer loans with social attestation</Subhead>
            <CallToAction  mt={3}><Link to="/getting-started" >Get Started</Link></CallToAction>
            <ScrollDownIndicator />
          </Hero>
        </Provider>
    );
  }
}