//
//  USAStates.swift
//  ComprasUSACaseStudy
//
//  Created by Marcos Amaral on 21/04/24.
//

import Foundation

public enum USAStates: String, CaseIterable {
    case alaska
    case alabama
    case arkansas
    case arizona
    case california
    case colorado
    case connecticut
    case districtOfColumbia
    case delaware
    case florida
    case georgia
    case hawaii
    case iowa
    case idaho
    case illinois
    case indiana
    case kansas
    case kentucky
    case lousiana
    case massachusetts
    case maryland
    case maine
    case michigan
    case minnesota
    case missouri
    case mississippi
    case montana
    case northCarolina
    case northDakota
    case nebraska
    case newHampshire
    case newJersey
    case newMexico
    case nevada
    case newYork
    case ohio
    case oklahoma
    case oregon
    case pennsylvania
    case puertoRico
    case rhodeIsland
    case southCarolina
    case southDakota
    case tennessee
    case texas
    case utah
    case virginia
    case vermont
    case washington
    case wiscosin
    case westVirginia
    case wyoming
}

extension USAStates {
    public func name() -> String {
        switch self {
        case .alaska:
            return "Alaska"
        case .alabama:
            return "Alabama"
        case .arkansas:
            return "Arkansas"
        case .arizona:
            return "Arizona"
        case .california:
            return "California"
        case .colorado:
            return "Colorado"
        case .connecticut:
            return "Connecticut"
        case .districtOfColumbia:
            return "District of Columbia"
        case .delaware:
            return "Delaware"
        case .florida:
            return "Florida"
        case .georgia:
            return "Georgia"
        case .hawaii:
            return "Hawaii"
        case .iowa:
            return "Iowa"
        case .idaho:
            return "Idaho"
        case .illinois:
            return "Illinois"
        case .indiana:
            return "Indiana"
        case .kansas:
            return "Kansas"
        case .kentucky:
            return "kentucky"
        case .lousiana:
            return "Louisiana"
        case .massachusetts:
            return "Massachusetts"
        case .maryland:
            return "Maryland"
        case .maine:
            return "Maine"
        case .michigan:
            return "Michigan"
        case .minnesota:
            return "Minnesota"
        case .missouri:
            return "Missouri"
        case .mississippi:
            return "Mississippi"
        case .montana:
            return "Montana"
        case .northCarolina:
            return "North Carolina"
        case .northDakota:
            return "North Dakota"
        case .nebraska:
            return "Nebraska"
        case .newHampshire:
            return "New Hampshire"
        case .newJersey:
            return "New Jersey"
        case .newMexico:
            return "New Mexico"
        case .nevada:
            return "Nevada"
        case .newYork:
            return "New York"
        case .ohio:
            return "Ohio"
        case .oklahoma:
            return "Ohio"
        case .oregon:
            return "Oregon"
        case .pennsylvania:
            return "Pennsylvania"
        case .puertoRico:
            return "Puerto Rico"
        case .rhodeIsland:
            return "Rhode Island"
        case .southCarolina:
            return "South Carolina"
        case .southDakota:
            return "South Dakota"
        case .tennessee:
            return "Tennessee"
        case .texas:
            return "Texas"
        case .utah:
            return "Utah"
        case .virginia:
            return "Virginia"
        case .vermont:
            return "Vermont"
        case .washington:
            return "Washington"
        case .wiscosin:
            return "Wiscosin"
        case .westVirginia:
            return "West Virginia"
        case .wyoming:
            return "Wyoming"
        }
    }
}

extension USAStates {
    public func abbreviations() -> String {
        switch self {
        case .alaska:
            return "AK"
        case .alabama:
            return "AL"
        case .arkansas:
            return "AR"
        case .arizona:
            return "AZ"
        case .california:
            return "CA"
        case .colorado:
            return "CO"
        case .connecticut:
            return "CT"
        case .districtOfColumbia:
            return "DC"
        case .delaware:
            return "DE"
        case .florida:
            return "FL"
        case .georgia:
            return "GA"
        case .hawaii:
            return "HI"
        case .iowa:
            return "IA"
        case .idaho:
            return "ID"
        case .illinois:
            return "IL"
        case .indiana:
            return "IN"
        case .kansas:
            return "KS"
        case .kentucky:
            return "KY"
        case .lousiana:
            return "La"
        case .massachusetts:
            return "MA"
        case .maryland:
            return "MD"
        case .maine:
            return "ME"
        case .michigan:
            return "MI"
        case .minnesota:
            return "MN"
        case .missouri:
            return "MO"
        case .mississippi:
            return "MS"
        case .montana:
            return "MT"
        case .northCarolina:
            return "NC"
        case .northDakota:
            return "ND"
        case .nebraska:
            return "NE"
        case .newHampshire:
            return "NH"
        case .newJersey:
            return "NJ"
        case .newMexico:
            return "NM"
        case .nevada:
            return "NV"
        case .newYork:
            return "NY"
        case .ohio:
            return "OH"
        case .oklahoma:
            return "OK"
        case .oregon:
            return "OR"
        case .pennsylvania:
            return "PA"
        case .puertoRico:
            return "PR"
        case .rhodeIsland:
            return "RI"
        case .southCarolina:
            return "SC"
        case .southDakota:
            return "SD"
        case .tennessee:
            return "TN"
        case .texas:
            return "TX"
        case .utah:
            return "UT"
        case .virginia:
            return "VA"
        case .vermont:
            return "VT"
        case .washington:
            return "WA"
        case .wiscosin:
            return "WI"
        case .westVirginia:
            return "WV"
        case .wyoming:
            return "WY"
        }
    }
}
