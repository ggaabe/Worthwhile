//
//  ViewController.swift
//
//
//  Created by Gabe Garrett on 9/20/14.
//  Copyright (c) 2014 Gabriel Garrett. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate {

    @IBOutlet weak var myLabel: UILabel!
   

    @IBOutlet weak var hourglass: UIImageView!
    @IBOutlet weak var buttonProperties: UIButton!
    @IBOutlet weak var promptLabel: UILabel!
    //@IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var testDefaultLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var currencyButton: UIButton!
    var currentString = ""
    let tapRow = UITapGestureRecognizer()
    
    
    
    /*Array of data that indicates currency formatting
    Currently no way to automatically use currency choice to set
    locale formatter. Match each currency to its respective country's locale to continue.*/
    let pickerData = [
        "AED",
        "AFN",
        "ALL",
        "AMD",
        "ANG",
        "AOA",
        "ARS",
        "AUD",
        "AWG",
        "AZN",
        "BAM",
        "BBD",
        "BDT",
        "BGN",
        "BHD",
        "BIF",
        "BMD",
        "BND",
        "BOB",
        "BOV",
        "BRL",
        "BSD",
        "BTN",
        "BWP",
        "BYR",
        "BZD",
        "CAD",
        "CDF",
        "CHE",
        "CHF",
        "CHW",
        "CLF",
        "CLP",
        "CNY",
        "COP",
        "COU",
        "CRC",
        "CUP",
        "CVE",
        "CYP",
        "CZK",
        "DJF",
        "DKK",
        "DOP",
        "DZD",
        "EEK",
        "EGP",
        "ERN",
        "ETB",
        "EUR",
        "FJD",
        "FKP",
        "GBP",
        "GEL",
        "GHS",
        "GIP",
        "GMD",
        "GNF",
        "GTQ",
        "GYD",
        "HKD",
        "HNL",
        "HRK",
        "HTG",
        "HUF",
        "IDR",
        "ILS",
        "INR",
        "IQD",
        "IRR",
        "ISK",
        "JMD",
        "JOD",
        "JPY",
        "KES",
        "KGS",
        "KHR",
        "KMF",
        "KPW",
        "KRW",
        "KWD",
        "KYD",
        "KZT",
        "LAK",
        "LBP",
        "LKR",
        "LRD",
        "LSL",
        "LTL",
        "LVL",
        "LYD",
        "MAD",
        "MDL",
        "MGA",
        "MKD",
        "MMK",
        "MNT",
        "MOP",
        "MRO",
        "MTL",
        "MUR",
        "MVR",
        "MWK",
        "MXN",
        "MXV",
        "MYR",
        "MZN",
        "NAD",
        "NGN",
        "NIO",
        "NOK",
        "NPR",
        "NZD",
        "OMR",
        "PAB",
        "PEN",
        "PGK",
        "PHP",
        "PKR",
        "PLN",
        "PYG",
        "QAR",
        "RON",
        "RSD",
        "RUB",
        "RWF",
        "SAR",
        "SBD",
        "SCR",
        "SDG",
        "SEK",
        "SGD",
        "SHP",
        "SKK",
        "SLL",
        "SOS",
        "SRD",
        "STD",
        "SYP",
        "SZL",
        "THB",
        "TJS",
        "TMM",
        "TND",
        "TOP",
        "TRY",
        "TTD",
        "TWD",
        "TZS",
        "UAH",
        "UGX",
        "USD",
        "USN",
        "USS",
        "UYU",
        "UZS",
        "VEB",
        "VND",
        "VUV",
        "WST",
        "XAF",
        "XAG",
        "XAU",
        "XBA",
        "XBB",
        "XBC",
        "XBD",
        "XCD",
        "XDR",
        "XFO",
        "XFU",
        "XOF",
        "XPD",
        "XPF",
        "XPT",
        "XTS",
        "XXX",
        "YER",
        "ZAR",
        "ZMK",
        "ZWD"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.textField.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.hidden = true //picker wheel hidden until currency button is selected.
        
        tapRow.delegate = self
        tapRow.numberOfTapsRequired = 2 /*set to 2 because lets the user tap to scroll without instantly selecting an item unintentionally*/
        
        tapRow.addTarget(self, action: "selectRow")
        pickerView.addGestureRecognizer(tapRow)
        pickerView.userInteractionEnabled = true
        pickerView.selectRow(151, inComponent: 0, animated: false)
        currencyButton.setTitle("USD", forState: UIControlState.Normal)
        
        if(NSUserDefaults.standardUserDefaults().objectForKey("AppOpenFirstTime") == nil)
        {
            // App Open First time
            // Set salary to 0.00 and AppOpenFirstTime to a not nil value.
            
            NSUserDefaults.standardUserDefaults().setObject("1", forKey: "AppOpenFirstTime")
            
            NSUserDefaults.standardUserDefaults().setDouble(0.00, forKey: "salary")
        }
        else{
            if(NSUserDefaults.standardUserDefaults().valueForKey("salary") == nil){
                NSUserDefaults.standardUserDefaults().setDouble(0.00, forKey: "salary")}
        }
        if(NSUserDefaults.standardUserDefaults().valueForKey("salary") as Double == 0.00){
            promptLabel.text = "Enter your hourly wage:"
            buttonProperties.setTitle("Save", forState: UIControlState.Normal)
            
        }
        else{
            promptLabel.text = "Enter the cost of an item: "
        }
        if(NSUserDefaults.standardUserDefaults().valueForKey("AppOpenFirstTime") as String == "1"){
            var wage : Double = NSUserDefaults.standardUserDefaults().valueForKey("salary") as Double
            var wageString : String = "\(wage)"
            //testDefaultLabel.text = wageString;
        }
        
        resultLabel.text = NSUserDefaults.standardUserDefaults().valueForKey("salary") as? String   //just a test to print the user's wage for now.
        
    }
    
    @IBAction func buttonPressed(sender: AnyObject) {
        /** var number = textField.text.toInt()
        println(number)
        
        if(number != nil){
        var catAge = number! * 7
        var numberString = String(catAge)
        resultLabel.text = numberString + " years old"
        textField.text = ""
        }
        else{
        resultLabel.text = "Please enter a number."
        textField.text = ""
        }*/
        textField.resignFirstResponder()
        
        var locale = NSLocale.currentLocale()
        var formatter = NSNumberFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US")
       // formatter.locale = NSLocaleCurrencyCode.
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        
        
        var moneyDouble = formatter.numberFromString(textField.text)?.doubleValue
        
        //if the top label is a prompt for hourly wage, save the value to
        //user defaults when the button is pressed.
        if (promptLabel.text == "Enter your hourly wage:"){
            
            //  NSUserDefaults.standardUserDefaults().setDouble(NSString(string: textField.text).doubleValue, forKey: "salary")
            
            /*  var locale = NSLocale.currentLocale()
            var formatter = NSNumberFormatter()
            formatter.locale = NSLocale(localeIdentifier: "en_US")
            formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
            
            var moneyString = formatter.numberFromString(textField.text)?.doubleValue*/
            // println(moneyString);
            print(textField.text);
            
            //var currencyToDouble = NSNumberFormatterStyle.CurrencyStyle
            // var cTD : Double = Double(moneyString!)
            // println(cTD)
            NSUserDefaults.standardUserDefaults().setDouble(moneyDouble!, forKey: "salary")
            
            NSUserDefaults.standardUserDefaults().synchronize()
            promptLabel.text = "Enter the cost of an item: "
            textField.text = ""
            buttonProperties.setTitle("Enter", forState: UIControlState.Normal)
            
            
        }
        else{
            /*for(var x = 0; x <= 23; x++){
            var imageArray = NSArray.arrayByAddingObject()
            }*/
            
            /*for(var x = 0; x <= 23; x++){
            var imageAnimation = UIImage.animatedImageNamed("hourglass\(x).png", duration: 0.1)
            var nextImage = UIImage(named: "hourglass\(x).png");
            //sleep(1)
            var sleep: Void = NSThread.sleepForTimeInterval(0.1)
            hourglass.image = nextImage
            
            hourglass.startAnimating()
            }*/
            
            //var priceString = textField.text
            //var price : Double = NSString(string: priceString).doubleValue
            var price : Double = moneyDouble!
            var timeString = calculateTime(price)
            resultLabel.text = "This item will cost you \(timeString) of your life."
            
            
            var imgListArray :NSMutableArray = []
            for countValue in 0...23
            {
                
                var strImageName : String = "hourglass\(countValue).png"
                var image  = UIImage(named:strImageName)
                imgListArray.addObject(image!)
            }
            var lastImage = UIImage(named: "images/retry/hourglass23.png")
            self.hourglass.animationImages = imgListArray;
            self.hourglass.animationDuration = 0.75
            self.hourglass.animationRepeatCount = 1
            self.hourglass.image = imgListArray.objectAtIndex(imgListArray.count-1) as? UIImage
            self.hourglass.startAnimating()
            //self.hourglass.image = imgListArray.objectAtIndex(imgListArray.count-1) as? UIImage
            //self.hourglass.stopAnimating()
        }
        
    }

    
    @IBAction func currencyButtonPressed(sender: AnyObject) {
        textField.resignFirstResponder()
        pickerView.hidden = false
    }
    
         @IBAction func clear(sender: AnyObject) {
        textField.text = ""
        pickerView.hidden = true
        currentString = ""
    }
    @IBAction func changeWagePressed(sender: AnyObject) {
        if (promptLabel.text == "Enter your hourly wage:"){
            promptLabel.text = "Enter the cost of an item: "
            textField.text = ""
            buttonProperties.setTitle("Enter", forState: UIControlState.Normal)
        }
        
        else{
        changeWage()
        }
    }
    
    
    func changeWage(){
        
        /* promptLabel.text = "Enter your hourly wage:"
        
        var wage : Double = NSUserDefaults.standardUserDefaults().valueForKey("salary") as Double
        
        var wageString : String = "\(wage)"
        
        textField.text = wageString
        
        buttonProperties.setTitle("Save", forState: UIControlState.Normal)*/
        
        promptLabel.text = "Enter your hourly wage:"
        var currentWage: AnyObject! =  NSUserDefaults.standardUserDefaults().valueForKey("salary")
        textField.text = "\(currentWage)"
        resultLabel.text = ""
        buttonProperties.setTitle("Save", forState: UIControlState.Normal)
        
    }
    
    func calculateTime(price: Double) -> String{
        let salary : Double = NSUserDefaults.standardUserDefaults().valueForKey("salary") as Double
        if (price == 0){
            return "the present moment"
        }
        let initialSeconds = (price / salary) * 3600 //times 3600 because the salary is at an hourly rate. 1 hour = 3600 seconds
        var totalRemainingTime : Int = Int(initialSeconds)//initialize variable to be manipulated
        var x : Int;
        //var calculatedTime = ""
        var joiner = ", "
        var calculatedTime =  [String]()
        /*
            Deduct from total remaining time for each unit of time measured.
            */
        if(totalRemainingTime >= 31556926){//seconds in year
            x = Int(totalRemainingTime / 31556926)
            if(x == 1){
                calculatedTime.append("\(x) year")
            }
            else{
             calculatedTime.append("\(x) years")
            }
            totalRemainingTime -= (x * 31556926)
            x = 0
        }
        if(totalRemainingTime >= 2629743){ //month
            x = Int(totalRemainingTime / 2629743)
            if (x == 1){
                calculatedTime.append("\(x) month")
            }
            else{
             calculatedTime.append("\(x) months")
            }
            totalRemainingTime -= (x * 2629743)
            x = 0
        }
        if(totalRemainingTime >= 604800){ //week
            x = Int(totalRemainingTime / 604800)
            if(x == 1){
                calculatedTime.append("\(x) week")
            }
            else{
             calculatedTime.append("\(x) weeks")
            }
            totalRemainingTime -= (x * 604800)
            x = 0
        }
        if(totalRemainingTime >= 86400){ //day
            x = Int(totalRemainingTime / 86400)
            if(x == 1){
                calculatedTime.append("\(x) day")
            }
            else{
                calculatedTime.append("\(x) days")
            }
            totalRemainingTime -= (x * 86400)
            x = 0
        }
        if(totalRemainingTime >= 3600){ //hour
            x = Int(totalRemainingTime / 3600)
            if(x == 1){
                calculatedTime.append("\(x) hour")
            }
            else{
                calculatedTime.append("\(x) hours")
            }
            totalRemainingTime -= (x * 3600)
            x = 0
        }
        if(totalRemainingTime >= 60){
            x = Int(totalRemainingTime / 60)
            if(x == 1){
                calculatedTime.append("\(x) minute")
            }
            else{
                calculatedTime.append("\(x) minutes")
            }
            totalRemainingTime -= (x * 60)
            x = 0
        }
        if(totalRemainingTime > 0){
            x = totalRemainingTime
            if (x == 1){
                calculatedTime.append("\(x) second")
            }
            else{
                calculatedTime.append("\(x) seconds")
            }
            totalRemainingTime -= x
            x = 0
        }   /*using remainder for seconds works because the total is subtracted
              from for every unit of time measured and the original number used is in seconds.*/
        
        
        let finalTime = calculatedTime
        
        /*var calculatedString = (", ".join(calculatedTime[0...countElements(finalTime)-2]) + ", and " + calculatedTime.last!)*/
        
        
        
        var calculatedString = myJoin(calculatedTime)
        
        return calculatedString
    }
    
    func myJoin(var elements:[String]) -> String {
        let count = elements.count
        let separator = (count == 2) ? " " : ", "
        if count > 1 {
            elements[count - 1] = "and " + elements[count - 1]
        }
        
        return join(separator, elements)
    }
    
    
    @IBAction func editingEnded(sender: AnyObject) {
        /*
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = NSString(string: textField.text).doubleValue
        
        textField.text = formatter.stringFromNumber(numberFromField)*/
    }
    
    @IBAction func valueChange(sender: AnyObject) {
        
        
    }
    @IBAction func keyEntered(sender: AnyObject) {
        
        
    }
    @IBAction func editingDidBegin(sender: AnyObject) {
           /* textField.addTarget(self, action: Selector("textFieldDidChange:"), forControlEvents: UIControlEvents.EditingChanged)*/
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            //inserts number at the end of the string
            currentString += string
            println(currentString)
            formatCurrency(string: currentString)
            /*will need to insert 2 indexes away from the end
                to be placed beyond the decimal point*/
        default:
            var array = Array(string)
            //allows backspace
            var currentStringArray = Array(currentString)
            if array.count == 0 && currentStringArray.count != 0 {
                currentStringArray.removeLast()
                currentString = ""
                for character in currentStringArray {
                    currentString += String(character)
                }
                formatCurrency(string: currentString)
            }
        }
        return false
    }
    
    /*Formats the currency based on locale identifier.
        Will need to pass locale identifier as a variable
        to set later.
    */
    func formatCurrency(#string: String) {
        println("format \(string)")
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US")
        var numberFromField = (NSString(string: currentString).doubleValue)/100
        textField.text = formatter.stringFromNumber(numberFromField)
        println(textField.text )
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    //MARK: Delegates
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       // currencyButton.setTitle(pickerData[row], forState: UIControlState.Normal)
       // pickerView.hidden = true
    }
    
    func selectRow(){
        var currentRow = pickerView.selectedRowInComponent(0)
        currencyButton.setTitle(pickerData[currentRow], forState: UIControlState.Normal)
        pickerView.hidden = true
    
       /* let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)*/
    }
    
  //  var tapRecognizer = UITapGestureRecognizer.instanceMethodForSelector(pickerTapped)
    
    func gestureRecognizer(UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWithGestureRecognizer:UIGestureRecognizer) -> Bool {
            return true
    }
    
    func pickerTapped(){
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var tap: [UITapGestureRecognizer]!
    @IBAction func backTap(recognizer:UITapGestureRecognizer){
        textField.endEditing(true)
        //textField.resignFirstResponder()
    }

}

