//
//  ComplicationForms.swift
//  complicationsapp
//
//  Created by Ken Chen on 6/7/16.
//  Copyright © 2016 cvicu. All rights reserved.
//

import Eureka

// Creates a variable to hold all the forms generated for each complication
class ComplicationForms {
    
    // Keeps a reference to the view controller being used to display
    var vc: FormViewController?
    
    
    // Instantiates an empty Form dictionary
    var formDict = [String : Form]()
//    var nonsenseKeys = Complications.getEmptyDictArray(Complications.data)
    var nonsenseKeys = [String : [String]]()
    
    init(vc: FormViewController) {
        self.vc = vc
    }
    
    func createForm(logName: String) -> Form {
        var thisForm : Form
        switch logName {
            case "arrhythmialog":
                thisForm = createArr()
            case "cprlog":
                thisForm = createCPR()
            case "dsclog":
                thisForm = createDSC()
            case "infeclog":
                thisForm = createINFEC()
            case "lcoslog":
                thisForm = createLCOS()
            case "mcslog":
                thisForm = createMCS()
            case "odlog":
                thisForm = createOD()
            case "phlog":
                thisForm = createPH()
            case "reslog":
                thisForm = createRES()
            case "uoplog":
                thisForm = createUOP()
        default:
            thisForm = Form()
        }
        formDict[logName] = thisForm
        return thisForm
    }
    
    func createArr() -> Form {
        // ---------------------- Arrhythmia form ---------------------- //
        let arrForm = Form()
        
        arrForm +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            // Need to remove tag in form-processing
            <<< SLabelRow("Therapies present at discharge?") {
                $0.title = $0.tag
                $0.value = "YES"
                $0.cell.selectionStyle = .Default
            }.onCellSelection {cell, row in
                row.value = row.value! == "YES" ? "NO" : "YES"
                row.deselect()
                row.updateCell()
            }
            
            <<< DateTimeInlineRow("StopDate") {
                $0.title = "Stop date/time"
                $0.value = NSDate()
                $0.hidden = .Function(["Therapies present at discharge?"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Therapies present at discharge?") as! SLabelRow
                    return row.value! == "YES" ? true : false
                })
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("Type") {
                $0.title = "Type"
                $0.selectorTitle = "Which type of arrhythmia?"
                $0.options = [
                    "Atrial tachycardia",
                    "Ventricular tachycardia",
                    "Junctional tachycardia",
                    "Complete heart block",
                    "Second degree heart block",
                    "Sinus or junctional bradycardia"
                ]
                $0.value = "Enter"
                }.onChange { row in
                    print(row.value)
            }
            
//            <<< AlertRow<String>("Therapy") {
//                $0.title = "Therapy"
//                $0.value = "Enter"
//                $0.selectorTitle = "Which type of arrhythmia therapy?\n\nDefinition: Treatment with intravenous therapy (continuous infusion, bolus dosing, or electrolyte therapy)"
//                $0.options = [
//                    "Drug",
//                    "Electrical Cardioversion/Defibrillation",
//                    "Permanent Pacemaker / AICD",
//                    "Temporary Pacemaker",
//                    "Cooling < 35 degrees"
//                ]
//            }
            
            <<< MultipleSelectorRow<String>("Therapy") {
                $0.title = "Therapy"
                $0.options = [
                    "Drug",
                    "Electrical Cardioversion/Defibrillation",
                    "Permanent Pacemaker / AICD",
                    "Temporary Pacemaker",
                    "Cooling < 35 degrees"
                ]
                $0.selectorTitle = "Which type of arrhythmia therapy?\n\nDefinition: Treatment with intravenous therapy (continuous infusion, bolus dosing, or electrolyte therapy)"
            }
        
        return arrForm
    }
    
    func createCPR() -> Form {
        // ---------------------- CPR form ---------------------- //
        let cprForm = Form()
        
        cprForm +++ Section("Dates and times")
            
            <<< LabelRow() {
                $0.title = "USE CODE SHEET FOR ACCURATE TIMES"
            }
            
            <<< DateTimeInlineRow("startDate") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            <<< DateTimeInlineRow("endDate") {
                $0.title = "End date/time"
                $0.value = NSDate()
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("outcome") {
                $0.title = "CPR Outcome"
                $0.selectorTitle = "CPR Outcome"
                $0.options = ["ROSC", "ECMO", "DEATH"]
                $0.value = "Enter"
            }
            
            <<< AlertRow<String>("Hypothermia") {
                $0.title = "Hypothermia protocol"
                $0.selectorTitle = "Hypothermia protocol (<34 degrees)?\n\nNo implies hypothermia"
                $0.options = ["Yes", "No"]
                $0.value = "Enter"
        }
        return cprForm
    }
    
    func createDSC() -> Form {
        // ---------------------- dsc form ---------------------- //
        let dscForm = Form()
        
        dscForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "Planned"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Planned:\n\nSternum left open post-op with preop plans to leave sternum open"
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Unplanned"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Unplanned:\n\nSternum left open post-op without preop plans to leave sternum open"
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Date/Time"
                $0.value = NSDate()
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("Plan") {
                $0.title = "Planned or Unplanned"
                $0.selectorTitle = "Planned or Unplanned?"
                $0.options = ["Planned", "Unplanned"]
                $0.value = "Enter"
        }
        return dscForm
    }
    
    func createINFEC() -> Form {
        // ---------------------- Infections form ---------------------- //
        let infecForm = Form()
        
        infecForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "Endocarditis"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Endocarditis:\n\nDefined by modified Duke criteria."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "CLABSI"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "CLABSI:\n\nDefined by the CDC."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Sepsis"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Sepsis:\n\nPresence of SIRS resulting from suspected or proven infection. If within the first 48 hours post-op, SIRS due to sepsis is defined as hypo- or hyperthermia (>38.5 or <36), tachycardia, leukocytosis or leukopenia, and thrombocytopenia."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Superficial SSI"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Superficial Surgical Site Infection:\n\nAs defined by the CDC. Mark if only it has been adjudicated by the local infection control personnel.  Must meet the following numbered criteria: 1) The infection involves only the skin and the subcutaneous tissue of the incision and 2) The patient has at least ONE of the following lettered features: A) purulent drainage from the superficial portion of the incision, B) organisms isolated from an aseptically obtained culture of fluid or tissue from the superficial portion of the incision, C) at least ONE of the following numbered signs or symptoms: [1] pain or tenderness, [2] localized swelling, redness, or heat, and [3] the superficial portion of the incision is deliberately opened by a surgeon, unless the incision is culture negative, or D) a diagnosis of superficial wound."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Deep SSI"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Deep Surgical Site Infection:\n\nAs defined by the CDC. Mark if only it has been adjudicated by the local infection control personnel.  Involves the deep soft tissues (e.g., fascial and muscle layers) of the incision AND the patient has at least ONE of the following numbered features: 1) Purulent drainage from the deep portion of the incision (but not from the organ/space component of the surgical site and no evidence of sternal osteomyelitis), 2) The deep incision spontaneously dehisces or is deliberately opened by a surgeon when the patient has ONE of the following lettered signs or symptoms (unless the incision is culture negative): A) fever, B) localized pain, or C) tenderness, 3) An abscess or other evidence of infection involving the deep incision is found on direct examination, during reoperation, or by histopathologic or radiologic examination, or 4) A diagnosis of a deep wound infection by a surgeon or by an attending physician."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Mediastinits SSI"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Mediastinits Surgical Site Infection:\n\nCriterion 1: Patient has organisms cultured from mediastinal tissue or fluid that is obtained during a surgicaloperation or by needle aspiration.  Criterion 2. Patient has evidence of mediastinitis by histopathologic examination or visual evidence of mediastinitis seen during a surgical operation. Criterion 3: Patient has at least ONE of the following numbered signs or symptoms with no other recognized cause: 1) fever, 2) chest pain, or 3) sternal instability AND at least one of the following numbered features: 1) purulent mediastinal drainage, 2) organisms cultured from mediastinal blood, drainage or tissue, or 3) widening of the cardio-mediastinal silhouette. Criterion 4: Patient ≤ 1 year of age has at least one of the following numbered signs or symptoms with no other recognized cause: 1) fever, 2) hypothermia, 3) apnea, 4) bradycardia, or 5) sternal instability AND at least one of the following numbered features: 1) purulent mediastinal discharge, 2) organisms cultured from mediastinal blood, drainage or tissue, or 3) widening of the cardio-mediastinal silhouette. Infections of the sternum (sternal osteomyelitis) should be classified as mediastinitis. Sternal instability that is not associated with a wound infection or mediastinitis is documented as \"Sternal instability."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Meningitis"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Meningitis:\n\nAs defined by the CDC. Mark if only it has been adjudicated by the local infection control personnel."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "UTI"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "UTI:\n\nAs defined by the CDC. Mark if only it has been adjudicated by the local infection control personnel."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Endocarditis")
            
            // Remove tag in form-processing
            <<< SLabelRow("Endocarditis") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("END") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Endocarditis"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Endocarditis") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Pneumonia")
            
            // Remove tag in form-processing
            <<< SLabelRow("Pneumonia") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("PNE") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Pneumonia"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Pneumonia") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("CLABSI")
            
            // Remove tag in form-processing
            <<< SLabelRow("CLABSI") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("CLA") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["CLABSI"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("CLABSI") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("CLA Type") {
                $0.title = "CLABSI Type"
                $0.value = "Enter"
                $0.selectorTitle = "What type of CLABSI?"
                $0.options = [
                    "Gram negative",
                    "Gram positive",
                    "Mixed",
                    "Fungal",
                    "Unknown"
                ]
                $0.hidden = .Function(["CLABSI"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("CLABSI") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Sepsis")
            
            // Remove tag in form-processing
            <<< SLabelRow("Sepsis") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("SEP") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Sepsis"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Sepsis") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Surgical Site Infection")
            
            // Remove tag in form-processing
            <<< SLabelRow("Surgical Site Infection") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("SSI") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Surgical Site Infection"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Surgical Site Infection") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("SSI Type") {
                $0.title = "SSI Type"
                $0.value = "Enter"
                $0.selectorTitle = "What type of Surgical Site Infection?"
                $0.options = [
                    "Superficial",
                    "Deep",
                    "Mediastinits",
                    "Deep - Gram negative",
                    "Deep - Gram positive",
                    "Deep - Mixed",
                    "Deep - Fungal",
                    "Deep - Unknown"
                ]
                $0.hidden = .Function(["Surgical Site Infection"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Surgical Site Infection") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Meningitis")
            
            // Remove tag in form-processing
            <<< SLabelRow("Meningitis") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("MEN") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Meningitis"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Meningitis") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("UTI")
            
            // Remove tag in form-processing
            <<< SLabelRow("UTIinfec") {
                $0.title = "UTI"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("UTI") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["UTIinfec"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("UTIinfec") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("UTI Type") {
                $0.title = "UTI Type"
                $0.value = "Enter"
                $0.selectorTitle = "What type of UTI?"
                $0.options = [
                    "Gram negative",
                    "Gram positive",
                    "Mixed",
                    "Fungal",
                    "Unknown"
                ]
                $0.hidden = .Function(["UTIinfec"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("UTIinfec") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
        }
        return infecForm
    }
    
    func createLCOS() -> Form {
        // ---------------------- LCOS form ---------------------- //
        let lcosForm = Form()
        
        lcosForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "LCOS"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Low Cardiac Output Syndrome:\n\nLCOS defined by at least one of the following:\n1. VIS > 15 at any time,\n2. Addition of new vasoactive agent (not esmolol or nirpride) for patients already on vasopressor support,\n3. New initiation of vasactive support after a 24 hour period with no support,\n4. Widened A-V difference by physician,\n5. Clinical diagnosis of LCOS."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Severe Cardiac Failure"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Severe Cardiac Failure:\n\nLow cardiac output state characterized by some of the following: tachycardia, oliguria, decreased skin perfusion, need for increased inotropic support (10% above baseline at admission), metabolic acidosis, widened Arterial - Venous oxygen saturation, need to open the chest, or need for mechanical support. This complication should be selected if the cardiac dysfunction is of a severity that results in inotrope dependence, mechanical circulatory support, or listing for cardiac transplantation. A patient will be considered to have “inotrope dependence” if they cannot be weaned from inotropic support (10% above baseline at admission) after any period of 48 consecutive hours that occurs after the time of OR Exit Date and Time and either (1) within 30 days after surgery in or out of the hospital, and (2) after 30 days during the same hospitalization subsequent to the operation."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Confirmation")
            
            // Remove tag in form-processing
            <<< SLabelRow("Confirmation") {
                $0.title = "Are you a Data Manager?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            +++ Section("Dates and times"){
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            <<< LabelRow () {
                $0.title = "Do not enter: to be adjudicated by Data Manager"
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                }.onCellSelection {cell, row in
                    self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            +++ Section("Details"){
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            <<< LabelRow () {
                $0.title = "Do not enter: to be adjudicated by Data Manager"
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                }.onCellSelection {cell, row in
                    self.displayAlert(row.title!, message: "")
            }
            
            <<< AlertRow<String>("LCOST") {
                $0.title = "LCOS Timing"
                $0.selectorTitle = "LCOS Timing"
                $0.options = ["Pre-Op", "Post-Op", "Both", "N/A"]
                $0.value = "Enter"
            }
            
            <<< SLabelRow("SCF") {
                $0.title = "Severe cardiac failure?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
        }
        return lcosForm
    }
    
    func createMCS() -> Form {
        // ---------------------- MCS form ---------------------- //
        let mcsForm = Form()
        
        mcsForm +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            // Remove tag in form-processing
            <<< SLabelRow("Confirmation") {
                $0.title = "Are you a Data Manager?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
            }.onCellSelection {cell, row in
                row.value = row.value! == "YES" ? "NO" : "YES"
                row.deselect()
                row.updateCell()
            }
            
            <<< LabelRow() {
                $0.title = "Do not enter: to be adjudicated by Data Manager"
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }.onCellSelection {cell, row in
                self.displayAlert(row.title!, message: "")
            }
            
            // FIXME: nil results in unwrapping error, so need to hide this
            <<< DateTimeInlineRow("MCSE") {
                $0.title = "MCS end date/time"
                $0.value = NSDate()
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Details")
            
            <<< SLabelRow("In post-ope period") {
                $0.title = "In post-operative period?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
            }.onCellSelection {cell, row in
                row.value = row.value! == "YES" ? "NO" : "YES"
                row.deselect()
                row.updateCell()
            }
            
            <<< AlertRow<String>("SupportType") {
                $0.title = "Support type"
                $0.value = "Enter"
                $0.selectorTitle = "Select support type"
                $0.options = ["VAD", "ECMO", "Both VAD and ECMO"]
            }
            
            <<< AlertRow<String>("Reason") {
                $0.title = "Primary reason"
                $0.value = "Enter"
                $0.selectorTitle = "Select primary reason for MCS"
                $0.options = [
                    "LCOS/Cardiac failure",
                    "Ventricular dysfunction",
                    "Hypoxemia",
                    "Hypercardic respiratory failure",
                    "Shunt occlusion",
                    "Arrhythmia",
                    "Bleeding",
                    "Multisystem organ failure"
                ]
            }
            
            <<< AlertRow<String>("ECPR") {
                $0.title = "ECPR"
                $0.value = "Enter"
                $0.selectorTitle = "Enter ECPR"
                $0.options = [
                    "Active CPR at cannulation",
                    "Active CPR within 2 hours of cannulation"
                ]
            }
            
            <<< SLabelRow("MCSS") {
                $0.title = "MCS present at start..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< AlertRow<String>() {
                $0.title = "Full description"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "MCS present at start of CICU encounter?"
                } .onChange { row in
                    row.value = "Press to view"
        }
        return mcsForm
    }
    
    func createOD() -> Form {
        // ---------------------- ORGAN DYSFUNCTION form ---------------------- //
        let odForm = Form()
        
        odForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "MSOF"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Multi-System Organ Failure/Dysfunction:\n\nMulti-System Organ Failure (MSOF) is a condition where more than one organ system has failed (for example, respiratory failure requiring mechanical ventilation combined with renal failure requiring dialysis). Please code the individual organ system failures as well. If MSOF is associated with sepsis as well, please also code: Sepsis, Multi-system Organ Failure. Multi-System Organ Failure (MSOF) is synonymous with Multi-Organ Dysfunction Syndrome (MODS). Only code this complication if the patient has failure of two or more than two organs. Do not code MSOF if only failing organs are the heart and lungs."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "RFRD"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Renal failure requiring dialysis at the time of hospital discharge:\n\nCode if patient requires dialysis at the time of hospital discharge or death in the hospital.  (Acute renal failure defined as new onset oliguria with sustained urine output < 0.5 cc/kg/hr for 24 hours and/or a rise in creatinine > 1.5 time upper limits of normal for age (or twice the most recent preop/preprocedural values, with eventual need for dialysis (including peritoneal) or hemofiltration.   Within 30 days of operation/procedure in or out of the hospital or anytime during same hospitalzation.  Code if the patient required dialysis, but the treatment was not instiuted due to patient or family refusal."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Transient"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Transient:\n\nNot present at discharge."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Seizure"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Seizure:\n\nClinical and/or EEG evidence."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Stroke"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Stroke:\n\nAny confirmed neurological deficit of abrupt onset caused by a disturbance in blood flow to the brain, when the neurological definict does not resolve within 24 hours."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Wound dehiscence (sterile)"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Wound dehiscence (sterile):\n\nSeparation can be superficial or deep."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Multi-System Organ Failure")
            
            // Remove tag in form-processing
            <<< SLabelRow("MSOF") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("msof") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["MSOF"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("MSOF") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("MSOF Type") {
                $0.title = $0.tag
                $0.value = "Enter"
                $0.selectorTitle = "What type of MSOF?"
                $0.options = [
                    "Sepsis, MSOF",
                    "Renal Failure requiring dialysis",
                    "Liver failure",
                    "Neurological",
                    "Other"
                ]
                $0.hidden = .Function(["MSOF"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("MSOF") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Renal failure requiring dialysis at the time of hospital discharge")
            
            // Remove tag in form-processing
            <<< SLabelRow("Renal failure requiring dialysis at the time of hospital discharge") {
                $0.title = "RFRD"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("RFRD") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Renal failure requiring dialysis at the time of hospital discharge"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Renal failure requiring dialysis at the time of hospital discharge") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("RFRD Type") {
                $0.title = $0.tag
                $0.value = "Enter"
                $0.selectorTitle = "What type of RFRD?"
                $0.options = [
                    "Requiring dialysis at time of hospital discharge",
                    "Requiring temporary dialysis",
                    "Requiring temporary hemofiltration"
                ]
                $0.hidden = .Function(["Renal failure requiring dialysis at the time of hospital discharge"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Renal failure requiring dialysis at the time of hospital discharge") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Neurological deficit")
            
            // Remove tag in form-processing
            <<< SLabelRow("Neurological deficit") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("ND") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Neurological deficit"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Neurological deficit") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            // Remove tag in form-processing
            <<< AlertRow<String>("ND Presence") {
                $0.title = "Transient?"
                $0.value = "Enter"
                $0.selectorTitle = "Transient?"
                $0.options = [
                    "Persistenting at discharge",
                    "Transient"
                ]
                $0.hidden = .Function(["Neurological deficit"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Neurological deficit") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Peripheral nerve injury, persistenting at discharge")
            
            // Remove tag in form-processing
            <<< SLabelRow("Peripheral nerve injury, persistenting at discharge") {
                $0.title = "Peripheral nerve injury..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("PNI") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Peripheral nerve injury, persistenting at discharge"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Peripheral nerve injury, persistenting at discharge") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Seizure")
            
            // Remove tag in form-processing
            <<< SLabelRow("Seizure") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("seizure") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Seizure"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Seizure") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Spinal cord injury")
            
            // Remove tag in form-processing
            <<< SLabelRow("Spinal cord injury") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("SCI") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Spinal cord injury"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Spinal cord injury") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Stroke")
            
            // Remove tag in form-processing
            <<< SLabelRow("Stroke") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("stroke") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Stroke"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Stroke") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            <<< SLabelRow("SB") {
                $0.title = "Subdural bleed"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                $0.hidden = .Function(["Stroke"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Stroke") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< SLabelRow("IH") {
                $0.title = "Interventricular hemorrhage..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                $0.hidden = .Function(["Stroke"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Stroke") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< AlertRow<String>() {
                $0.title = "Full description"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Interventricular hemorrhage (IVH > 2)"
                $0.hidden = .Function(["Stroke"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Stroke") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Wound dehiscence (sterile)")
            
            // Remove tag in form-processing
            <<< SLabelRow("Wound dehiscence (sterile)") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("wound") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Wound dehiscence (sterile)"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Wound dehiscence (sterile)") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Median sternotomy")
            
            // Remove tag in form-processing
            <<< SLabelRow("Median sternotomy") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("MS") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Median sternotomy"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Median sternotomy") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
        }
        return odForm
    }
    
    func createPH() -> Form {
        // ---------------------- ph form ---------------------- //
        let phForm = Form()
        
        phForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "Pulmonary Hypertension"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Pulmonary Hypertension:\n\nClinically significant elevation of PA pressure, requiring intervention such as iNO or other therapies. This does not include iNO given for hypoxemia when there was clearly no PHTN."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "PHC"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Pulmonary hypertensive crisis (Acute state of PAp > Systemic pressure):\n\nAn acute state of inadequate systemic perfusion associated with pulmonary hypertension, when the pulmonary arterial pressure is greater than the systemic arterial pressure."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Start date/time"
                $0.value = NSDate()
            }
            
            // Need to remove tag in form-processing
            <<< SLabelRow("Therapy present at discharge?") {
                $0.title = $0.tag
                $0.value = "YES"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            // Remove tag in form-processing
            <<< SLabelRow("Confirmation") {
                $0.title = "Are you a Data Manager?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                $0.hidden = .Function(["Therapy present at discharge?"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Therapy present at discharge?") as! SLabelRow
                    return row.value! == "YES" ? true : false
                })
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    
            }
            
            <<< LabelRow () {
                $0.title = "Do not enter: to be adjudicated by Data Manager"
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
                }.onCellSelection {cell, row in
                    self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("endDate") {
                $0.title = "Stop date/time"
                $0.value = NSDate()
                $0.hidden = .Function(["Confirmation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Confirmation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Details")
            
            <<< AlertRow<String>("Treatment") {
                $0.title = "Treatment"
                $0.selectorTitle = "Treatment"
                $0.options = [
                    "iNO",
                    "Inhaled iloprost",
                    "Prostacyclin",
                    "Remodulin"
                ]
                $0.value = "Enter"
                }.onChange { row in
                    print(row.value)
            }
            
            // Need to remove tag in form-processing
            <<< SLabelRow("PHC") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
        }
        return phForm
    }
    
    func createRES() -> Form {
        // ---------------------- RESPIRATORY form ---------------------- //
        let resForm = Form()
        
        resForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "Chylothorax"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Chylothorax requiring intervention:\n\nChylothorax defined as presence of lymphatic fluid in the pleural space (predominance of lymphocytes and/or a triglyceride level greater than 110 mg/dL). Change in diet is considered an intervention."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "ARDS"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "ARDS:\n\nARDS is defined as a clinical syndrome with a variety of etiologies characterized by refractory hypoxemia and bilateral diffuse interstitial infiltrates on CXR, as well as stiff lungs with decreased compliance, increased intrapulmonary shunting, and decreased airway dead space."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Pulmonary embolism"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Pulmonary embolism:\n\nEmbolization of clot or other foreign material to the pulmonary vasculature documented by CT angiogram, nuclear medicine scan or other accepted objective study."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Reintubation..."
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Post-operative/Post-procedureal respiratory insufficiency requiring reintubation:\n\nWithin 30 days of surgery. Not intended to capture situations where a patient may undergo elective intubations."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "Paralyzed Diaphragm"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Paralyzed Diaphragm:\n\nPresence of elevated hemi-diaphragm(s) on chest radiograph in conjunction with evidence of weak, immobile or paradoxical movement assessed by ultrasound or fluoroscopy."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Necessary to place a chest tube?")
            
            // Remove tag in form-processing
            <<< SLabelRow("NPCT") {
                $0.title = "Necessary to place a chest tube?"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("Necessary to place a chest tube?") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["NPCT"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("NPCT") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Chylothorax requiring intervention")
            
            // Remove tag in form-processing
            <<< SLabelRow("chylothorax") {
                $0.title = "Chylothorax requiring intervention"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("Chylothorax requiring intervention") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["chylothorax"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("chylothorax") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Pleural effusion requiring drainage")
            
            // Remove tag in form-processing
            <<< SLabelRow("pleuraleffusion") {
                $0.title = "Pleural effusion requiring drainage"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("Pleural effusion requiring drainage") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["pleuraleffusion"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("pleuraleffusion") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Pneumothorax requiring drainage")
            
            // Remove tag in form-processing
            <<< SLabelRow("pneumothorax") {
                $0.title = "Pneumothorax requiring drainage"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("Pneumothorax requiring drainage") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["pneumothorax"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("pneumothorax") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Hemothorax requiring drainage")
            
            // Remove tag in form-processing
            <<< SLabelRow("hemothorax") {
                $0.title = "Hemothorax requiring drainage"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
            <<< DateTimeInlineRow("Hemothorax requiring drainage") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["hemothorax"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("hemothorax") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("ARDS")
            
            // Remove tag in form-processing
            <<< SLabelRow("ards") {
                $0.title = "ARDS"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("ARDS") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["ards"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("ards") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Pulmonary embolism")
            
            // Remove tag in form-processing
            <<< SLabelRow("pulmembol") {
                $0.title = "Pulmonary embolism"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("Pulmonary embolism") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["pulmembol"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("pulmembol") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Post-operative/Post-procedural respiratory insufficiency requiring mechanical ventilatory support")
            
            // Remove tag in form-processing
            <<< SLabelRow("Post-operative/Post-procedureal respiratory insufficiency requiring mechanical ventilatory support") {
                $0.title = "Mechanical ventilatory support..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
//            <<< AlertRow<String>() {
//                $0.title = "Full description"
//                $0.value = "Press to view"
//                $0.options = ["Accept"]
//                $0.selectorTitle = "Mechanical ventilatory support: Post-operative/Post-procedureal respiratory insufficiency requiring mechanical ventilatory support"
//                } .onChange { row in
//                    row.value = "Press to view"
//            }
            
            <<< DateTimeInlineRow("pprirmvs") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Post-operative/Post-procedureal respiratory insufficiency requiring mechanical ventilatory support"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Post-operative/Post-procedureal respiratory insufficiency requiring mechanical ventilatory support") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Post-operative/Post-procedural respiratory insufficiency requiring reintubation")
            
            // Remove tag in form-processing
            <<< SLabelRow("Post-operative/Post-procedureal respiratory insufficiency requiring reintubation") {
                $0.title = "Reintubation..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
//            <<< AlertRow<String>() {
//                $0.title = "Full description"
//                $0.value = "Press to view"
//                $0.options = ["Accept"]
//                $0.selectorTitle = "Reintubation: Post-operative/Post-procedureal respiratory insufficiency requiring reintubation"
//                } .onChange { row in
//                    row.value = "Press to view"
//            }
            
            <<< DateTimeInlineRow("pprirr") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["Post-operative/Post-procedureal respiratory insufficiency requiring reintubation"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("Post-operative/Post-procedureal respiratory insufficiency requiring reintubation") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Respiratory failure requiring tracheostomy")
            
            // Remove tag in form-processing
            <<< SLabelRow("rfrt") {
                $0.title = "Respiratory failure req..."
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
                    //self.displayAlert(row.title!, message: "")
            }
            
//            <<< AlertRow<String>() {
//                $0.title = "Full description"
//                $0.value = "Press to view"
//                $0.options = ["Accept"]
//                $0.selectorTitle = "Respiratory failure requiring tracheostomy"
//                } .onChange { row in
//                    row.value = "Press to view"
//            }
            
            <<< DateTimeInlineRow("Respiratory failure requiring tracheostomy") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["rfrt"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("rfrt") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Paralyzed diaphragm")
            
            // Remove tag in form-processing
            <<< SLabelRow("pd") {
                $0.title = "Paralyzed diaphragm"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("Paralyzed diaphragm") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["pd"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("pd") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
            }
            
            +++ Section("Vocal cord dysfunction")
            
            // Remove tag in form-processing
            <<< SLabelRow("vcd") {
                $0.title = "Vocal cord dysfunction"
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            <<< DateTimeInlineRow("Vocal cord dysfunction") {
                $0.title = "Date/Time"
                $0.value = NSDate()
                $0.hidden = .Function(["vcd"], { form -> Bool in
                    let row : RowOf! = form.rowByTag("vcd") as! SLabelRow
                    return row.value! == "NO" ? true : false
                })
        }
        return resForm
    }
    
    func createUOP() -> Form {
        // ---------------------- Unplanned operation/Procedure form ---------------------- //
        let uopForm = Form()
        
        uopForm +++ Section("Definitions")
            
            <<< AlertRow<String>() {
                $0.title = "UCR"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Unplanned cardiac reoperation:\n\nAdditional unplanned cardiac reoperation during the hospital encounter or within 30 days after surgery in or out of the hospital. Delayed sternal closure, ECMO decannulation, VAD decannulation, and removal of Broviac catheter should not be included. Unplanned reoperations include Mediastinal exploration for infection or hemodynamic instability, initiation of ECMO or VAD."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "UICC"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Unplanned interventional cardiovascular catheterization in the post-op period:\n\nDuring the hospital encounter or within 30 days after procedure in or out of the hospital."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            <<< AlertRow<String>() {
                $0.title = "UNR"
                $0.value = "Press to view"
                $0.options = ["Accept"]
                $0.selectorTitle = "Unplanned non-cardiac reoperation during the post-op period:\n\nDuring the hospital encounter or within 30 days after procedure in or out of the hospital."
                } .onChange { row in
                    row.value = "Press to view"
            }
            
            +++ Section("Dates and times")
            
            <<< DateTimeInlineRow("date_1") {
                $0.title = "Date/Time"
                $0.value = NSDate()
            }
            
            +++ Section("Details")
            
            // Need to remove tag in form-processing
            <<< SLabelRow("UCR") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            // Need to remove tag in form-processing
            <<< SLabelRow("UICC") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
            }
            
            // Need to remove tag in form-processing
            <<< SLabelRow("UNR") {
                $0.title = $0.tag
                $0.value = "NO"
                $0.cell.selectionStyle = .Default
                }.onCellSelection {cell, row in
                    row.value = row.value! == "YES" ? "NO" : "YES"
                    row.deselect()
                    row.updateCell()
        }
        return uopForm
    }
    
    // Cleans tags and combines multiple values of form in formDict associated with logName
    func cleanTagsAndGetCombinedValues(logName: String) -> [String : String] {
        var values = convertAllValuesToString(formDict[logName]!.values())
        switch logName {
        case "arrhythmialog":
            values.removeValueForKey("Therapies present at discharge?")
        case "cprlog":
            break
        case "dsclog":
            break
        case "infeclog":
            // If CLABSI was filled out
            if (values.keys.contains("CLABSI") && values["CLABSI"]! == "YES") {
                values["CLA"] = values["CLA Type"]! + " (\(values["CLA"]!))"
                values.removeValueForKey("CLA Type")
            }
            
            // If SSI was filled out
            if (values.keys.contains("Surgical Site Infection") && values["Surgical Site Infection"]! == "YES") {
                values["SSI"] = "\(values["SSI Type"]!) (\(values["SSI"]!))"
                values.removeValueForKey("SSI Type")
            }
            
            // If UTI was filled out
            if (values.keys.contains("UTIinfec") && values["UTIinfec"]! == "YES") {
                values["UTI"] = "\(values["UTI Type"]!) (\(values["UTI"]!))"
                values.removeValueForKey("UTI Type")
            }
            
            let toChange = [
                "Endocarditis" : "END",
                "Pneumonia" : "PNE",
                "CLABSI" : "CLA",
                "Sepsis" : "SEP",
                "Surgical Site Infection" : "SSI",
                "Meningitis" : "MEN",
                "UTIinfec" : "UTI"
            ]
            
            for (key, value) in toChange {
                if (values[key]! == "NO") {
                    values[value] = "NO"
                }
                values.removeValueForKey(key)
            }
        case "lcoslog":
            values.removeValueForKey("Confirmation")
        case "mcslog":
            values.removeValueForKey("Confirmation")
        case "odlog":
            // If MSOF was filled out
            if (values.keys.contains("MSOF") && values["MSOF"]! == "YES") {
                values["msof"] = "\(values["MSOF Type"]!) (\(values["msof"]!))"
                values.removeValueForKey("MSOF Type")
            }
            
            // If RFRD was filled out
            let RFRD = "Renal failure requiring dialysis at the time of hospital discharge"
            if (values.keys.contains(RFRD) && values[RFRD]! == "YES") {
                values["RFRD"] = "\(values["RFRD Type"]!) (\(values["RFRD"]!))"
                values.removeValueForKey("RFRD Type")
            }
            
            // If ND was filled out
            if (values.keys.contains("Neurological deficit") && values["Neurological deficit"]! == "YES") {
                values["ND"] = "\(values["ND Presence"]!) (\(values["ND"]!))"
                values.removeValueForKey("ND Presence")
            }
            
            let toChange = [
                "MSOF" : "msof",
                RFRD : "RFRD",
                "Neurological deficit" : "ND",
                "Peripheral nerve injury, persistenting at discharge" : "PNI",
                "Seizure" : "seizure",
                "Spinal cord injury" : "SCI",
                "Stroke" : "stroke",
                "Wound dehiscence (sterile)" : "wound",
                "Median sternotomy" : "MS"]
            
            for (key, value) in toChange {
                if (values[key]! == "NO") {
                    values[value] = "NO"
                }
                values.removeValueForKey(key)
            }
        case "phlog":
            values.removeValueForKey("Therapy present at discharge?")
            values.removeValueForKey("Confirmation")
        case "reslog":
            let toChange = [
                "NPCT" : "Necessary to place a chest tube?",
                "chylothorax" : "Chylothorax requiring intervention",
                "pleuraleffusion" : "Pleural effusion requiring drainage",
                "pneumothorax" : "Pneumothorax requiring drainage",
                "hemothorax" : "Hemothorax requiring drainage",
                "ards" : "ARDS",
                "pulmembol" : "Pulmonary embolism",
                "Post-operative/Post-procedureal respiratory insufficiency requiring mechanical ventilatory support" : "pprirmvs",
                "Post-operative/Post-procedureal respiratory insufficiency requiring reintubation" : "pprirr",
                "rfrt" : "Respiratory failure requiring tracheostomy",
                "pd" : "Paralyzed diaphragm",
                "vcd" : "Vocal cord dysfunction"
            ]
            for (key, value) in toChange {
                if (values[key]! == "NO") {
                    values[value] = "NO"
                }
                values.removeValueForKey(key)
            }
        case "uoplog":
            break
        default:
            print("Invalid log to cleanTagsAndGetCombinedValues: \(logName)")
        }
        
        return values
    }
    
    func extractDataAndCleanForms() {
        for key in formDict.keys {
            
            // reset confirmObject to postObject
            let data = SessionData.sharedInstance
            data.confirmObject = data.postObject
            
            let toAdd = cleanTagsAndGetCombinedValues(key)
            data.confirmObject = data.addData(data.confirmObject, toAdd: toAdd)
            
            // check for any concurrent logging date conflicts
            let isDisabled = Complications.disabledDate.contains(data.confirmObject["Table"]!)
            let dateVariable = Complications.mainDate[SessionData.sharedInstance.postObject["Table"]!]!
            let dateToCheck = isDisabled ? SessionData.getCurrentTimeString() : data.confirmObject[dateVariable]!
            
            let responseString = SessionData.sharedInstance.checkDateFromServer(dateToCheck)
            if (responseString.characters.count > 0) {
                displayAlert("Warning", message: "This patient was already logged for this complication on \(dateToCheck) at these times:\n\n\(responseString)\n\nAre you sure you want to continue?")
            }
        }
    }
    
    // MARK: - Helper functions
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.vc!.presentViewController(alert, animated: true, completion: nil)
    }
    
    func convertAllValuesToString(dict: [String : Any?]) -> [String : String] {
        var result = [String : String]()
        for key in dict.keys {
            var thisValue = dict[key]!
            if (thisValue == nil) {
                result[key] = "null"
            } else {
                thisValue = thisValue!
            }
            
            if (thisValue is Int) {
                result[key] = String(thisValue)
            } else if (thisValue is Bool) {
                result[key] = (thisValue as! Bool == true) ? "YES" : "NO"
            } else if (thisValue is NSDate) {
                let df = NSDateFormatter()
                df.timeZone = NSTimeZone(abbreviation: "PST")
                df.dateFormat = "MM/dd/yyyy HH:mm"
                result[key] = df.stringFromDate(thisValue as! NSDate)
            } else if (thisValue is String?) {
                result[key] = (thisValue as! String?)!
            } else if (thisValue is [String]) {
                result[key] = (thisValue as! [String]).joinWithSeparator(" + ")
            }
        }
        return result
    }
    
}
