import React from "react";
import { Link } from "react-router-dom";

import "bootstrap/dist/css/bootstrap.min.css";
import "shards-ui/dist/css/shards.min.css"

import { Box, Flex, Heading, Image } from 'rimble-ui'
import {
  Hero, CallToAction, ScrollDownIndicator
} from 'react-landing-page'
import PrimaryNav from "../PrimaryNav";

type MyState = {};

export class LandingPage extends React.Component<{}, MyState> {
  render() {
    return (
        <Flex flexDirection="column">
          <Box width={1} >
            <PrimaryNav></PrimaryNav>
          </Box>
          <Box width={1} justifyContent="center" pt={144} pb={72}>
              <Heading.h1 textAlign="center">Stablecoin Loans</Heading.h1>
              <Heading.h6 textAlign="center" fontWeight="500" pb={48}>Enabling opportunity through borderless credit</Heading.h6>
              <Box width={1/2} pl={1/4}>
                <Image src="">
                </Image>
              </Box>
              <ScrollDownIndicator />
          </Box>
          <Box width={1} justifyContent="center" pt={144} pb={72}>
              <Heading.h4 textAlign="center" >How it works</Heading.h4>
          </Box>
        </Flex>
    );
  }
}