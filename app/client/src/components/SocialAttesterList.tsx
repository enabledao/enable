import React from "react";
import { SocialAttester } from "./SocialAttester";
import { SocialAttesterData } from "../interfaces/Users";

interface MyProps {
    data: SocialAttesterData[];
}

export class SocialAttesterList extends React.Component<MyProps, any> {
    render() {
        const listItems = this.props.data.map((item) =>
            <li key={item.toString()}>
                <SocialAttester data={item} />
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