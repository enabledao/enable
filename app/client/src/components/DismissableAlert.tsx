import React from "react";
import { Alert } from "shards-react";

interface MyProps {
    message: string
}

interface MyState {
    visible: boolean
    message: string
}

export class DismissibleAlert extends React.Component<MyProps, MyState> {
    constructor(props) {
        super(props);
        this.dismiss = this.dismiss.bind(this);
        this.state = { visible: true, message: this.props.message };
    }

    render() {
        return (
            <Alert dismissible={this.dismiss} open={this.state.visible}>
            {this.state.message}
                
      </Alert>
        );
    }

    dismiss() {
        this.setState({ visible: false });
    }
}