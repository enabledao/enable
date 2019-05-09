import React from "react";

import { SocialAttesterData } from "../interfaces/Users";


interface MyProps {
    data: SocialAttesterData;
}

export class SocialAttester extends React.Component<MyProps, any> {
    render() {
        const {name, relationship, img} = this.props.data;

        return (
            <div>
                <p>name</p>
                <p>Relationship</p>
                <img src={img}></img>
                {/* Static identity icons */}
            </div>
        );
    }
}