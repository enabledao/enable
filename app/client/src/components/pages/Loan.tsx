import React from "react";
import { string, number } from "prop-types";
import { Link } from "react-router-dom";
import { SocialIcon } from "react-social-icons";

import { PublicAddress } from "rimble-ui";
import {
  Container,
  Row,
  Col,
  Card,
  CardBody,
  Badge,
  CardHeader,
  Form,
  FormInput,
  InputGroup,
  InputGroupAddon,
  InputGroupText,
  Button,
  Progress,
  CardTitle,
  CardImg,
  CardFooter
} from "shards-react";
import "../../styles/Loan.css";
import SmallStats from "../common/SmallStats";

import dBox from "../../assets/3dbox.svg";
import bloomLogo from "../../assets/bloom-logo.svg";
import profilePic from "../../assets/img/avatars/0.jpg";
import cornellPic from "../../assets/img/ines/cornell.jpg";

import { EthereumComponent } from "../EthereumComponent";
import {
  ContributerMetadata,
  LoanMetadata,
  LoanParams,
  TokenMetadata,
  UserMetadata,
  RepaymentData,
  StakerMetadata
} from "../../interfaces";
import { database } from "../../data/database";
import { LoanHeader } from "../loan/LoanHeader";
import { AvatarList, AvatarListData } from "../AvatarList";
import { UserData } from "./UserProfile";
import { LoanFunding } from "../LoanFunding";

var LoanRequest = require("../../contractabi/LoanRequest.json");
var LoanRequestFactory = require("../../contractabi/LoanRequestFactory.json");
var UserStaking = require("../../contractabi/UserStaking.json");

type MyState = {
  web3: any;
  contributors: AvatarListData[];
  loanParams: LoanParams;
  loanMetadata: LoanMetadata;
  userData: UserData;
  tokenMetadata: TokenMetadata;
  isLoaded: boolean;
};

export class Loan extends EthereumComponent {
  state: MyState;

  constructor(props) {
    super(props);
    this.state = {
      contributors: [] as AvatarListData[],
      loanParams: {} as LoanParams,
      loanMetadata: {} as LoanMetadata,
      userData: {} as UserData,
      tokenMetadata: {} as TokenMetadata,
      isLoaded: false,
      web3: null
    };
  }

  // @dev Get icons and names of contributors if they have shared their data, or ethereum blockie and address if not
  async getContributors(): Promise<AvatarListData[]> {
    return [] as AvatarListData[];
  }

  async getStakers(userAddress: string): Promise<string[]> {
    return [] as string[];
  }

  /*
    Get a list of attestations, and the relevant data for each parsed down to what we need. The user gives these to the app via bloom when they create their account, or later. We then store the attestations in our datastore and display them to the potential lenders. Some information may be kept private which the lenders and borrower can communicate directly about
  */
  async getAttestations(userAddress: string): Promise<any> {
    return {};
  }

  // @dev Web3 call to get loan parameters from chain
  async getLoanParameters(): Promise<LoanParams> {
    return {} as LoanParams;
  }

  // @dev Get loan metadata from our servers or possibly IPFS
  async getLoanMetadata(): Promise<LoanMetadata> {
    return {} as LoanMetadata;
  }

  async getTokenMetadata(tokenAddress: string): Promise<TokenMetadata> {
    console.log(database.tokens.get(tokenAddress));
    return database.tokens.get(tokenAddress);
  }

  async getUserMetadata(userId: number): Promise<UserMetadata> {
    return database.users.get(userId);
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
          text: "USDC"
        }
      ],
      loanParams: {
        principal: 60000,
        fundsRaised: 48000,
        interestRate: 6,
        tenor: 120,
        gracePeriod: 24,
        repayments: 100,
        repaymentSchedule: [],
        loanCurrency: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
      },
      loanMetadata: {
        location: "Jakarta, Indonesia",
        purpose: "University",
        description:
          "Student loan for Masters Degree in Human Resources at Cornell University, with the intention to work in the US HR sector post-graduation.",
        userStory:
          "Student loan for Masters Degree in Human Resources at Cornell University, with the intention to work in the US HR sector post-graduation.",
        imgSrc: ""
      },
      userData: {
        name: "Ines"
      },
      isLoaded: true
    });

    //Contract Instances
    if (!this.state.web3) {
      //Connect ot infura - at the previous component
    }

    // var MyContract = contract({
    //   abi: ...,
    //   unlinked_binary: ...,
    //   address: ..., // optional
    //   // many more
    // })

    //Will get real data
    const contributors = await this.getContributors();
    const loanParams = await this.getLoanParameters();
    const tokenMetadata = await this.getTokenMetadata(
      this.state.loanParams.loanCurrency
    );

    this.setState({
      tokenMetadata: tokenMetadata
    });
  }

  get getLoan() {
    return {
      category: "Education",
      metadata: Object.assign({}, this.state.loanMetadata, {
        imgSrc:
          "https://cdn.pixabay.com/photo/2017/02/17/23/15/duiker-island-2076042_960_720.jpg"
      }),
      borrower: {
        address: "0x0",
        metadata: this.state.userData
      },
      articles: [{ name: "Medium Post", url: "weee" }],
      documents: [{ name: "Cornell Admission Letter", url: "weee" }]
    };
  }

  render() {
    const {
      contributors,
      loanParams,
      loanMetadata,
      userData,
      isLoaded,
      tokenMetadata
    } = this.state;
    const percentFunded = (loanParams.fundsRaised / loanParams.principal) * 100;

    return (
      <Container className="main-content-container py-4 px-4">
        <Row className="py-4">
          <Col lg="4" md="12" sm="12" className="py-2">
            <Card
              small
              className="card-post h-100 text-left"
              style={{
                backgroundImage: `url('${cornellPic}')`,
                backgroundSize: `cover`
              }}
            >
              <div
                style={{
                  background: `linear-gradient(0deg, rgba(8, 8, 8, 0.76) 27%, rgba(0, 0, 0, 0.26) 100%)`,
                  borderRadius: `7px`
                }}
                className="h-100"
              >
                <div className="card-post__image card-post--aside card-post--1 app__loan-feature-title">
                  <Badge pill className={`card-post__category bg-success`}>
                    Education
                  </Badge>
                  <Row>
                    <div className="card-post__author app__loan-feature-borrower-name">
                      <div className="app__loan-feature-borrower-name-large">
                        Widya Imanesti
                      </div>
                      <div>Cornell University</div>
                    </div>
                    <div className="card-post__author d-flex app__loan-feature-borrower-image ml-auto mr-3">
                      <a
                        href="#"
                        className="card-post__author-avatar card-post__author-avatar--small app__loan-feature-borrower-image"
                        style={{ backgroundImage: `url('${profilePic}')` }}
                      >
                        Written by Anna Ken
                      </a>
                    </div>
                  </Row>
                </div>
              </div>
            </Card>
          </Col>
          <Col lg="8" md="12" sm="12" className="py-2">
            <Card className="card-post h-100 text-left">
              <CardBody>
                <h5>
                  <strong>Loan Purpose</strong>
                </h5>
                <p>
                  Student loan for Masters Degree in Human Resources at Cornell
                  University, with the intent to work in the US Human Resources
                  sector post-graduation.
                </p>
                <Button theme="primary">Medium Post</Button>
              </CardBody>
            </Card>
          </Col>
        </Row>
        <Row>
          <Col lg="6" className="py-2">
            <Card small className="card-post h-100 text-left">
              <CardHeader className="border-bottom">
                <h6 className="m-0">Identity</h6>
              </CardHeader>
              <CardBody>
                <Row>
                  <Col>
                    <PublicAddress address="0x99cb784f0429efd72wu39fn4256n8wud4e01c7d2" />
                  </Col>
                </Row>
                <Row>
                  <Col>
                    <Button
                      theme="primary"
                      className="mb-2 mr-3 app__bloom-color"
                    >
                      Bloom ID
                    </Button>
                    <Button theme="primary" className="mb-2 mr-3">
                      3Box ID
                    </Button>
                  </Col>
                </Row>
                <Row>
                  <Col>
                    <strong className="text-muted d-block my-2">
                      Verified Accounts
                    </strong>
                  </Col>
                </Row>
                <Row>
                  <Col>
                    <SocialIcon
                      url="https://linkedin.com"
                      className="mx-1 app__social-icon"
                    />
                    <SocialIcon
                      url="https://twitter.com/jaketrent"
                      className="mx-1 app__social-icon"
                    />
                    <SocialIcon
                      url="https://facebook.com"
                      className="mx-1 app__social-icon"
                    />
                    <SocialIcon
                      url="https://instagram.com"
                      className="mx-1 app__social-icon"
                    />
                  </Col>
                </Row>
              </CardBody>
            </Card>
          </Col>
          <Col lg="6" className="py-2">
            <Card small className="blog-comments h-100 text-left">
              <CardHeader className="border-bottom">
                <h6 className="m-0">Social Attestation</h6>
              </CardHeader>
              <CardBody className="p-0">
                <div className="blog-comments__item d-flex p-3">
                  {/* Avatar */}
                  <div className="blog-comments__avatar mr-3">
                    <img src={profilePic} alt={"hi"} />
                  </div>
                  {/* Content */}
                  <div className="blog-comments__content">
                    {/* Content :: Title */}
                    <div className="blog-comments__meta text-mutes">
                      <a className="text-secondary" href={"#"}>
                        Husband
                      </a>
                      <span className="text-mutes">- 2 days ago</span>
                    </div>

                    {/* Content :: Body */}
                    <p className="m-0 my-1 mb-2 text-muted">Husband</p>
                  </div>
                  {/* Content :: Actions */}
                  <div className="blog-comments__actions ml-auto align-self-center">
                    <Button theme="primary" className="mx-2 app__bloom-color">
                      Bloom ID
                    </Button>
                    <Button theme="primary" className="mx-2">
                      3Box
                    </Button>
                  </div>
                </div>
                <div className="blog-comments__item d-flex p-3">
                  {/* Avatar */}
                  <div className="blog-comments__avatar mr-3">
                    <img src={profilePic} alt={"hi"} />
                  </div>
                  {/* Content */}
                  <div className="blog-comments__content">
                    {/* Content :: Title */}
                    <div className="blog-comments__meta text-mutes">
                      <a className="text-secondary" href={"#"}>
                        Daniel Onggunhao
                      </a>
                      <span className="text-mutes">- 2 days ago</span>
                    </div>

                    {/* Content :: Body */}
                    <p className="m-0 my-1 mb-2 text-muted">Colleague</p>
                  </div>
                  {/* Content :: Actions */}
                  <div className="blog-comments__actions ml-auto align-self-center">
                    <Button theme="primary" className="mx-2 app__bloom-color">
                      Bloom ID
                    </Button>
                    <Button theme="primary" className="mx-2">
                      3Box
                    </Button>
                  </div>
                </div>
              </CardBody>
            </Card>
          </Col>
        </Row>
        <Row className="justify-content-center pt-4 pb-2">
          <h4>
            <strong>Loan Terms</strong>
          </h4>
        </Row>
        <Row>
          <Col md="6" sm="6" className="col-lg mb-4">
            <SmallStats
              variation="1"
              label="principal"
              value="60,000"
              subheader="USDC"
              increase="11293"
            />
          </Col>
          <Col md="6" sm="6" className="col-lg mb-4">
            <SmallStats
              variation="1"
              label="interest"
              value="6%"
              subheader="EFFECTIVE ANNUAL"
              increase="11293"
            />
          </Col>
          <Col md="6" sm="6" className="col-lg mb-4">
            <SmallStats
              variation="1"
              label="tenor"
              value="12"
              subheader="YEARS"
              increase="11293"
            />
          </Col>
          <Col md="6" sm="6" className="col-lg mb-4">
            <SmallStats
              variation="1"
              label="grace period"
              value="2"
              subheader="YEARS"
              increase="11293"
            />
          </Col>
          <Col md="6" sm="6" className="col-lg mb-4" s>
            <SmallStats
              variation="1"
              label="expected return"
              value="36%"
              subheader="INTEREST"
              increase="11293"
            />
          </Col>
        </Row>
        <Row className="mt-4">
          <Col lg="6" className="py-2">
            <Card className="card-post h-100 text-left">
              <CardBody className="app__funding-bg text-white">
                <h4 className="text-white">
                  <strong>Funding</strong>
                </h4>
                <h6 className="text-white">My Amount</h6>
                <Form>
                  <Row form>
                    <Col md="6" className="form-group">
                      <InputGroup>
                        <InputGroupAddon type="append">
                          <InputGroupText>USDC</InputGroupText>
                        </InputGroupAddon>
                        <FormInput
                          className="app__funding-form font-weight-bold"
                          value="1,000"
                          onChange={() => {}}
                        />
                      </InputGroup>
                    </Col>
                    <Col md="6">
                      <Button
                        theme="success"
                        className="app__funding-form font-weight-bold w-50"
                      >
                        Fund
                      </Button>
                    </Col>
                  </Row>
                </Form>
              </CardBody>
            </Card>
          </Col>
          <Col lg="6" className="py-2">
            <Card className="card-post h-100 text-left">
              <CardBody>
                <h4>
                  <strong>Progress</strong>
                </h4>
                <Row className="mt-3">
                  <Col className="app__funding-progress-text">
                    <span>$48,982</span> of $60,000 goal
                  </Col>
                </Row>
                <Progress
                  theme="primary"
                  style={{ height: "10px" }}
                  className="mb-2"
                  value={40}
                />
                <Row>
                  <Col>From 8 potential investors</Col>
                </Row>
              </CardBody>
            </Card>
          </Col>
        </Row>
        <Row className="py-4">
          <Col>
            <Card small className="mb-4">
              <CardHeader className="border-bottom text-left">
                <h6 className="m-0">Repayment Schedule</h6>
              </CardHeader>
              <CardBody className="p-0 pb-3 overflow-auto">
                <table className="table mb-0">
                  <thead className="bg-light">
                    <tr>
                      <th scope="col" className="border-0">
                        #
                      </th>
                      <th scope="col" className="border-0">
                        Days
                      </th>
                      <th scope="col" className="border-0">
                        Date
                      </th>
                      <th scope="col" className="border-0">
                        Paid Date
                      </th>
                      <th scope="col" className="border-0">
                        Principal Due
                      </th>
                      <th scope="col" className="border-0">
                        Balance of Loan
                      </th>
                      <th scope="col" className="border-0">
                        Interest
                      </th>
                      <th scope="col" className="border-0">
                        Fees
                      </th>
                      <th scope="col" className="border-0">
                        Penalties
                      </th>
                      <th scope="col" className="border-0">
                        Due
                      </th>
                      <th scope="col" className="border-0">
                        Paid
                      </th>
                      <th scope="col" className="border-0">
                        In Advance
                      </th>
                      <th scope="col" className="border-0">
                        Late
                      </th>
                      <th scope="col" className="border-0">
                        Outstanding
                      </th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>1</td>
                      <td>31</td>
                      <td>01 Oct 2019</td>
                      <td />
                      <td>0</td>
                      <td>60,000</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                    </tr>
                    <tr>
                      <td>1</td>
                      <td>31</td>
                      <td>01 Oct 2019</td>
                      <td />
                      <td>0</td>
                      <td>60,000</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                    </tr>
                    <tr>
                      <td>1</td>
                      <td>31</td>
                      <td>01 Oct 2019</td>
                      <td />
                      <td>0</td>
                      <td>60,000</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                    </tr>
                    <tr>
                      <td>1</td>
                      <td>31</td>
                      <td>01 Oct 2019</td>
                      <td />
                      <td>0</td>
                      <td>60,000</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                      <td>0</td>
                      <td>0</td>
                      <td>0</td>
                      <td>300</td>
                    </tr>
                  </tbody>
                </table>
              </CardBody>
            </Card>
          </Col>
        </Row>
      </Container>
      // <div className="tight-page" style={{ marginTop: "48px" }}>
      //   <LoanHeader
      //     loan={this.getLoan}
      //   />

      //   <Flex className="section-row" >
      //     <Box p={3} width={1 / 2} color="black" bg="white">
      //       <Card>
      //         <CardBody>
      //           <Flex >
      //             <Box width={2 / 4}>
      //               <Heading.h2 className="SF-Pro-Display-Semibold" textAlign="left">Identity</Heading.h2>
      //             </Box>
      //             <Box width={2 / 4}>
      //               <div style={{ position: "relative", marginTop: "-20px", marginRight: "-5px", width: "100%" }}>
      //                 <Text textAlign="right" className="SF-Pro-Display-Light gray">Powered by</Text>
      //                 <div className="powered-by">
      //                   <a href="https://https://3box.io/" target="_blank"><Image src={dBox} /></a>
      //                   <a href="https://bloom.co/" target="_blank"><Image src={bloomLogo} /></a>
      //                 </div>
      //               </div>
      //             </Box>
      //           </Flex>
      //           <div>
      //             <PublicAddress
      //               className="pubAddress"
      //               address={this.getLoan.borrower.address}
      //               label=""
      //             />
      //           </div>
      //         </CardBody>
      //       </Card>
      //     </Box>
      //     <Box p={3} width={1 / 2} color="black" bg="white">

      //       <Card>
      //         <CardBody>
      //           <h2>{percentFunded}% Funded</h2>
      //           <Progress theme="primary" value={percentFunded} />
      //           <Text>Total Amount ${loanParams.principal}</Text>
      //           <Text>Powered by {contributors.length} lenders</Text>

      //         </CardBody>
      //       </Card>
      //     </Box>
      //   </Flex>

      //   <Flex>
      //     <Box p={3} width={1 / 2} color="black" bg="white">
      //       <Card>
      //         <CardBody>
      //           <h3>{userData.name}'s Story</h3>
      //           <p>{loanMetadata.userStory}</p>
      //         </CardBody>
      //       </Card>
      //     </Box>
      //     <Box p={3} width={1 / 2} color="black" bg="white">

      //       <Card>
      //         <CardBody>
      //           <h3>Loan Details</h3>
      //           <Text>Principal: ${loanParams.principal} {tokenMetadata.name}</Text>
      //           <Text>Interest: {loanParams.interestRate}% Effective Annual</Text>
      //           <Text>Tenor: {loanParams.tenor / 12} Years</Text>
      //           <Text>Grace Period: {loanParams.gracePeriod / 12} Years</Text>
      //           <Text>Expected Return: {36}%</Text>
      //         </CardBody>
      //       </Card>

      //       <LoanFunding></LoanFunding>
      //       {/* 6<h3>Repayment Schedule</h3> */}
      //     </Box>
      //   </Flex>

      //   <Flex>
      //     <Box p={3} width={1 / 2} color="black" bg="white">
      //       <Card>
      //         <CardBody>
      //           <h3>Contributors</h3>
      //           <AvatarList data={contributors}></AvatarList>
      //         </CardBody>
      //       </Card>
      //     </Box>
      //   </Flex>
      // </div>
    );
  }
}
