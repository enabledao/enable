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
  email: string;
};

export class EmailOptIn extends React.Component {
  state: MyState

  constructor(props) {
    super(props);

    this.submitEmail = this.submitEmail.bind(this);
    this.onChange = this.onChange.bind(this);

    this.state = {
        email: ""
    };
  }

  onChange(field, value) {
    this.setState({
        [field]: value
    });
  }

  submitEmail() {
      console.log('submit')
    //TODO Implement email Registration
  }

  render() {
    return (
        <Flex flexDirection="column" className="email-opt-in" theme="success">
            <Heading.h2 className="SF-Pro-Display-Semibold">Get Updates</Heading.h2>
            <Heading.h4 className="SF-Pro-Display-Light" > A lot is going on in the kitchen. Be the first to know when the dish is ready.</Heading.h4>
            <Box width={"60%"} mt={12} mb={24} ml="auto" mr="auto" className="form-box">
                <Form onSubmit={e => e.preventDefault() || this.submitEmail()}>
                    <FormGroup>
                        <FormInput placeholder="Email address" className="mb-2" required type="email" value={this.state.email} onChange={e=>this.onChange('email', e.target.value)} />
                    </FormGroup>
                    <Button type="submit" outline theme="light"> Submit </Button>
                </Form>
            </Box>
        </Flex>
    );
  }
}