import React from "react";

import { faSave, faUserGraduate } from "@fortawesome/free-solid-svg-icons";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import "../../styles/LoanHeader.css"

import { Flex, Box, Heading, Image, Link, Text } from 'rimble-ui';
import {
    Badge,
    Button,
    Card,
    CardBody,
    Dropdown,
    DropdownToggle,
    DropdownMenu,
    DropdownItem,
  } from "shards-react";

import { Loan } from '../../interfaces/Loans';


interface MyState {
  postsOpen: boolean;
  resourcesOpen: boolean;
};

interface Props {
  loan?: Loan;
}

export class LoanHeader extends React.Component {
    state: MyState
    props: Props

    constructor(props) {
        super(props);

        this.toggleDropdown = this.toggleDropdown.bind(this);

        this.state = {
            postsOpen: false,
            resourcesOpen: false
        };
    }

    toggleDropdown (dropdownName) {
        this.setState({
            ...this.state,
            ...{
                [dropdownName]: !this.state[dropdownName]
            }
        });
    }

    render() {
        return (
            <Flex p={16} className="loanHeader section-row" >
                <Card className="loanCard">
                    <CardBody>
                        <Flex height={250} >
                            <Box width={"40%"} color="black" bg="white">
                                <div className="loanImage-overlay" style={{ background: `url(${this.props.loan.metadata.imgSrc}) no-repeat` }}>
                                    <Flex className="userSection" flexDirection="column" p={32} width={"100%"} height={"100%"} color="white" bg="rgba(0,0,0,0.7)">
                                        <Box width={1}>
                                            { this.props.loan.category &&
                                                <Badge pill theme={'success'}>
                                                    <span className="category-pill" >
                                                        {this.props.loan.category } Loan
                                                    </span>
                                                </Badge>
                                            }
                                        </Box>
                                        <Box width={1} style={{flexGrow: 1}}></Box>
                                        <Box width={1}>
                                            <Flex width={1} >
                                                <Box width={"80%"}>
                                                    <Heading.h2>
                                                        {this.props.loan.borrower.metadata.name}
                                                    </Heading.h2>
                                                    <Heading.h5>
                                                        {this.props.loan.metadata.location}
                                                    </Heading.h5>
                                                </Box>
                                                <Box width={"20%"}>
                                                    {this.props.loan.borrower.metadata.imgSrc ?
                                                        (<Image className="user-avatar" src={this.props.loan.borrower.metadata.imgSrc} />) :
                                                        (<div><FontAwesomeIcon className="user-avatar" icon={faUserGraduate} /></div>)
                                                    }
                                                </Box>
                                            </Flex>
                                        </Box>
                                    </Flex>
                                </div>
                            </Box>
                            <Box className="loanSection" width={"60%"} color="black" bg="white" pl={48} pr={48} pt={32} pb={32}>
                                <Flex flexDirection="column" width={"100%"} height={"100%"} color="black" >
                                    <Heading.h3>
                                        Loan Purpose
                                    </Heading.h3>
                                    <Box width={1} style={{flexGrow: 1}}>
                                        <Text className="grey" >{ this.props.loan.metadata.description}</Text>
                                    </Box>
                                    <Box width={1} className="articles">
                                        <div style={{ display: "inline-block" }}>
                                            { this.props.loan.articles && (Object.keys(this.props.loan.articles).length > 1) && typeof this.props.loan.articles[0] === "object" ?
                                                ( <Dropdown
                                                    open={this.state.postsOpen}
                                                    toggle={e=>this.toggleDropdown("postsOpen")}
                                                >
                                                    <DropdownToggle caret>
                                                        Articles
                                                    </DropdownToggle>
                                                    <DropdownMenu>
                                                        {
                                                            Object.keys(this.props.loan.articles).map( ind =>
                                                                <DropdownItem key={this.props.loan.articles[ind].name} className=""><Link href={this.props.loan.articles[ind].url} target="blank">{this.props.loan.articles[ind].name}</Link></DropdownItem>
                                                            )
                                                        }
                                                    </DropdownMenu>
                                                </Dropdown> )
                                                :
                                                (this.props.loan.articles && this.props.loan.articles[0] ?
                                                    <Link href={this.props.loan.articles[0].url} target="blank">
                                                        <Button disabled={!Boolean(this.props.loan.articles[0].url)} className="">
                                                            {this.props.loan.articles[0].name}
                                                        </Button>
                                                    </Link>
                                                    :
                                                    <Button disabled={true} className="">
                                                        No post
                                                    </Button>
                                                )
                                            }
                                        </div>
                                        <div style={{ display: "inline-block", marginLeft: "24px" }}>
                                            { this.props.loan.documents && (Object.keys(this.props.loan.documents).length > 1) && typeof this.props.loan.documents[0] === "object" ?
                                                ( <Dropdown
                                                    open={this.state.resourcesOpen}
                                                    toggle={e=>this.toggleDropdown("resourcesOpen")}
                                                >
                                                    <DropdownToggle caret outline>
                                                        <FontAwesomeIcon icon={faSave} />
                                                        Documents
                                                    </DropdownToggle>
                                                    <DropdownMenu>
                                                        {
                                                            Object.keys(this.props.loan.documents).map( ind =>
                                                                <DropdownItem key={this.props.loan.documents[ind].name} className=""><Link outline href={this.props.loan.documents[ind].url} target="blank">{this.props.loan.documents[ind].name}</Link></DropdownItem>
                                                            )
                                                        }
                                                    </DropdownMenu>
                                                </Dropdown> )
                                                :
                                                (this.props.loan.documents && this.props.loan.documents[0] ?
                                                    <Link href={this.props.loan.documents[0].url} target="blank">
                                                        <Button outline disabled={!Boolean(this.props.loan.documents[0].url)} className="">
                                                            <FontAwesomeIcon icon={faSave} />
                                                            {this.props.loan.documents[0].name}
                                                        </Button>
                                                    </Link>
                                                    :
                                                    <Button outline disabled={true} className="">
                                                        <FontAwesomeIcon icon={faSave} />
                                                        No document
                                                    </Button>
                                                )
                                            }
                                        </div>
                                    </Box>
                                </Flex>
                            </Box>
                        </Flex>
                    </CardBody>
                </Card>
            </Flex>
        );
    }
}