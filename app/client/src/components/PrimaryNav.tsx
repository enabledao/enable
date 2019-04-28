import React from "react";
import { Link } from "react-router-dom";
import {
  Button,
  Dropdown,
  DropdownToggle,
  DropdownMenu,
  DropdownItem,
  Navbar,
  NavbarToggler,
  NavbarBrand,
  Nav,
  NavItem,
  NavLink,
  Collapse
} from "shards-react";
import { Heading } from 'rimble-ui'

interface MyState  {
  collapseOpen: boolean;
  dropdownOpen: boolean;
};

export class PrimaryNav extends React.Component<{}, MyState> {
  state: MyState

  constructor(props) {
    super(props);

    this.toggleNavbar = this.toggleNavbar.bind(this);

    this.state = {
      collapseOpen: false,
      dropdownOpen: false
    };
  }

  toggleDropdown() {
    this.setState({
      ...this.state,
      ...{
        dropdownOpen: !this.state.dropdownOpen
      }
    });
  }

  toggleNavbar() {
    this.setState({
      ...this.state,
      ...{
        collapseOpen: !this.state.collapseOpen
      }
    });
  }

  render() {
    return (
      <Navbar type="dark" expand="md" style={{ background: "transparent", borderBottom: "solid 5px rgba(0,0,0,0.1)", padding: 0 }}>
        <NavbarBrand href="/">
          <Heading.h4>
            Enable
          </Heading.h4>
        </NavbarBrand>
        <NavbarToggler onClick={this.toggleNavbar} />

        <Collapse open={this.state.collapseOpen} navbar>
          <Nav navbar>
            <Dropdown
              open={this.state.dropdownOpen}
              toggle={this.toggleDropdown}
            >
              <DropdownToggle nav caret>
                Loans
              </DropdownToggle>
              <DropdownMenu>
                <DropdownItem><Link to="/loan/Education">Education</Link></DropdownItem>
                <DropdownItem><Link>Agriculture</Link></DropdownItem>
                <DropdownItem><Link>Mission-driven Orgs</Link></DropdownItem>
              </DropdownMenu>
            </Dropdown>
          </Nav>

          <Nav navbar className="ml-auto">
            <NavItem>
              <Link to="/dashboard">
                <Button theme="primary">
                  Dashboard
                </Button>
              </Link>
            </NavItem>          
          </Nav>
        </Collapse>
      </Navbar>
    );
  }
}