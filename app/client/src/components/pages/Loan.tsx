import React from "react";
import { Flex, Box, Text } from 'rimble-ui';
import { Link } from "react-router-dom";
import { AvatarList, AvatarListData } from "../AvatarList";
import {
  Card,
  CardHeader,
  CardTitle,
  CardImg,
  CardBody,
  CardFooter,
  Button,
  Progress
} from "shards-react";
import { string } from "prop-types";
import { UserData } from "./UserProfile";

interface LoanMetadata {
  country: string;
  purpose: string;
  description: string;
  userStory: string;
  imgSrc: string;
}

interface LoanParams {
  principal: number;
  fundsRaised: number;
  interestRate: number;
  repaymentTenor: number;
  repayments: number;
  repaymentSchedule: [];
  loanCurrency?: string;
}

type MyState = {
  contributors: AvatarListData[];
  loanParams: LoanParams;
  loanMetadata: LoanMetadata;
  userData: UserData;
  isLoaded: boolean;
};

export class Loan extends React.Component<{}, MyState> {

  constructor(props) {
    super(props);
    this.state = {
      contributors: [] as AvatarListData[],
      loanParams: {
        principal: 0,
        fundsRaised: 0,
        interestRate: 0,
        repaymentTenor: 0,
        repayments: 0,
        repaymentSchedule: [],
      },
      loanMetadata: {
        country: "",
        purpose: "",
        description: "",
        userStory: "",
        imgSrc: "",
      },
      userData: {} as UserData,
      isLoaded: false
    }
  }

  // @dev Get icons and names of contributors if they have shared their data, or ethereum blockie and address if not
  async getContributors(): Promise<AvatarListData[]> {
    return [] as AvatarListData[];
  }

  // @dev Web3 call to get loan parameters from chain
  async getLoanParameters(): Promise<LoanParams> {
    return {} as LoanParams;
  }

  // @dev Get loan metadata from our servers or possibly IPFS
  async getLoanMetadata(): Promise<LoanMetadata> {
    return {} as LoanMetadata;
  }

  async componentDidMount() {
    //Dummy Data
    this.setState({
      contributors: [
        {
          img: "https://airswap-token-images.s3.amazonaws.com/DAI.png",
          text: "Dai"
        },
        {
          img: "https://airswap-token-images.s3.amazonaws.com/DAI.png",
          text: "Dai"
        }
      ],
      loanParams: {
        principal: 60000,
        fundsRaised: 25000,
        interestRate: 5,
        repaymentTenor: 3,
        repayments: 100,
        repaymentSchedule: [],
      },
      loanMetadata: {
        country: "Indonesia",
        purpose: "University",
        description: "",
        userStory: "",
        imgSrc: "",
      },
      userData: {
        name: "Ines",
      },
      isLoaded: true
    });

    //Will get real data
    const contributors = await this.getContributors();
    const loanParams = await this.getLoanParameters();
  }

  render() {
    const { contributors, loanParams, loanMetadata, userData, isLoaded } = this.state;
    const percentFunded = loanParams.fundsRaised / loanParams.principal * 100;

    return (
      <div>

        // First Row
        <Flex>
          <Box p={3} width={1 / 2} color="black" bg="white">
          <Card>
              <CardBody>
                "User Image"
              </CardBody>
            </Card>
          </Box>
          <Box p={3} width={1 / 2} color="black" bg="white">
            <Card>
              <CardBody>
                <h2>{percentFunded}% Funded</h2>
                <Progress theme="primary" value={percentFunded} />
                <Text>Total Amount ${loanParams.principal}</Text>
                <Text>Powered by {contributors.length} lenders</Text>
                <h3>{userData.name}</h3>
                <Text>{loanMetadata.country} | {loanMetadata.purpose}</Text>
                <Text>"Default Amount + Call to action"</Text>
              </CardBody>
            </Card>
          </Box>
        </Flex>

        // Second Row
        <Flex>
          <Box p={3} width={1 / 2} color="black" bg="white">
            Loan Summary
          </Box>
        </Flex>

        // Third Row
        <Flex>
          <Box p={3} width={1 / 2} color="black" bg="white">
            <h3>{userData.name}'s Story</h3>

            <h3>Contributors</h3>
            <AvatarList data={contributors}></AvatarList>
          </Box>
          <Box p={3} width={1 / 2} color="black" bg="white">
            Box
          </Box>
        </Flex>
      </div>
    );
  }
}