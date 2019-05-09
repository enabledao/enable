import React from "react";
import {
  Button,
  Form,
  FormInput,
  FormGroup
} from "shards-react";
import { Box, Flex, Heading } from 'rimble-ui'

import "../styles/EmailOptIn.css";

interface MyState  {
  fundAmount: string;
};

export class LoanFunding extends React.Component {
  state: MyState

  constructor(props) {
    super(props);

    this.addFunding = this.addFunding.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
        fundAmount: ""
    };
  }

  onChange(field, value) {
    this.setState({
        [field]: value
    });
  }

  addFunding() {
      console.log('submit')
    //TODO Implement email Registration
  }

  render() {
    return (
        <Flex flexDirection="column" className="email-opt-in" theme="success">
            <Heading.h4 className="SF-Pro-Display-Light" >My Amount</Heading.h4>
            <Box width={"60%"} mt={12} mb={24} ml="auto" mr="auto" className="form-box">
                <Form onSubmit={e => e.preventDefault() || this.addFunding()}>
                    <FormGroup>
                        <FormInput placeholder="5,000" className="mb-2" required value={this.state.fundAmount} onChange={e=>this.onChange('fundAmount', e.target.value)} />
                    </FormGroup>
                    <Button type="submit" outline theme="light"> Submit </Button>
                </Form>
            </Box>
        </Flex>
    );
  }
}