// AssistantFlowModel.swift
import Observation
import Foundation


enum AssistantState {
    case idle
    case speaking
}


@Observable
class AssistantFlowModel {
    var assistantState = AssistantState.idle
}
