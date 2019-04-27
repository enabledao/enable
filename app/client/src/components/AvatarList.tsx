import React from "react";
import { Alert } from "shards-react";
import { Avatar, Text } from "rimble-ui";

export interface AvatarListData {
    img: string;
    text: string;
}

interface MyProps {
    data: AvatarListData[];
}

export class AvatarList extends React.Component<MyProps, any> {
    render() {
        const listItems = this.props.data.map((item) =>
            <li key={item.toString()}>
                <Avatar size="large" src="https://airswap-token-images.s3.amazonaws.com/DAI.png" />
                <Text>{item.text}</Text>
            </li>);

        return (
            <div>
                <ul>
                    {listItems}
                </ul>
            </div>
        );
    }
}