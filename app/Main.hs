import System.Process
import System.IO

htmlToPdf :: FilePath -> FilePath -> FilePath -> IO ()
htmlToPdf htmlFile cssFile pdfFile = do
  -- pandoc bill.html -s -o bill.pdf --css=styles.css --pdf-engine=weasyprint    
  let command = "pandoc"
      arguments = [htmlFile, "-s", "-o", pdfFile, "--css=styles.css", "--pdf-engine=weasyprint"]
  callProcess command arguments

writeHtmlToFile :: FilePath -> String -> IO ()
writeHtmlToFile filePath content = do
  writeFile filePath content
  putStrLn $ "HTML written to " ++ filePath

writeCssToFile :: FilePath -> String -> IO ()
writeCssToFile filePath content = do
  writeFile filePath content
  putStrLn $ "CSS written to " ++ filePath

main :: IO ()
main = do
  let
    cardholderName = "John Doe"
    cardNumber = "**** **** **** 1234"
    billingPeriodStart = "01 Mar 2025"
    billingPeriodEnd = "31 Mar 2025"
    statementDate = "01 Apr 2025"
    paymentDueDate = "20 Apr 2025"
    previousBalance = "$1,200.00"
    paymentsReceived = "-$500.00"
    purchases = "$350.00"
    interestCharges = "$18.50"
    newBalance = "$1,068.50"
    minimumPaymentDue = "$53.43"

    transactions = [
      ("05 Mar 2025", "Starbucks Coffee", "$6.45"),
      ("12 Mar 2025", "Amazon Purchase", "$89.99"),
      ("18 Mar 2025", "Netflix Subscription", "$15.99"),
      ("22 Mar 2025", "Grocery Store", "$105.00"),
      ("28 Mar 2025", "Gas Station", "$32.57")
      ]

    htmlContent =
      "<!DOCTYPE html>\n" ++
      "<html lang=\"en\">\n" ++
      "<head>\n" ++
      "  <meta charset=\"UTF-8\">\n" ++
      "  <!-- <title>Credit Card Bill Statement</title> -->\n" ++
      "  <link rel=\"stylesheet\" href=\"./styles.css\">\n" ++
      "</head>\n" ++
      "<body>\n" ++
      "  <h1>Credit Card Bill Statement</h1>\n" ++
      "  <div class=\"info\">\n" ++
      "    <p><b style=\"font-weight: 700;\">Cardholder Name:</b> " ++ cardholderName ++ "</p>\n" ++
      "    <p><b>Card Number: " ++ cardNumber ++ "</b></p>\n" ++
      "    <p><b>Billing Period:</b> " ++ billingPeriodStart ++ " - " ++ billingPeriodEnd ++ "</p>\n" ++
      "    <p><b>Statement Date:</b> " ++ statementDate ++ "</p>\n" ++
      "    <p><b>Payment Due Date:</b> " ++ paymentDueDate ++ "</p>\n" ++
      "  </div>\n" ++
      "  <h2>Account Summary</h2>\n" ++
      "  <table>\n" ++
      "    <tr>\n" ++
      "      <th>Description</th>\n" ++
      "      <th>Amount</th>\n" ++
      "    </tr>\n" ++
      concatMap (\(desc, amount) ->
        "    <tr>\n" ++ 
        "      <td>" ++ desc ++ "</td>\n" ++
        "      <td>" ++ amount ++ "</td>\n" ++
        "    </tr>\n"
      ) [
        ("Previous Balance", previousBalance),
        ("Payments Received", paymentsReceived),
        ("Purchases", purchases),
        ("Interest Charges", interestCharges),
        ("New Balance", newBalance),
        ("Minimum Payment Due", minimumPaymentDue)
        ] ++
      "  </table>\n" ++
      "  <h2>Transaction Details</h2>\n" ++
      "  <table>\n" ++
      "    <tr>\n" ++
      "      <th>Date</th>\n" ++
      "      <th>Description</th>\n" ++
      "      <th>Amount</th>\n" ++
      "    </tr>\n" ++
      concatMap (\(date, description, amount) ->
        "    <tr>\n" ++
        "      <td>" ++ date ++ "</td>\n" ++
        "      <td>" ++ description ++ "</td>\n" ++
        "      <td>" ++ amount ++ "</td>\n" ++
        "    </tr>\n"
      ) transactions ++
      "  </table>\n" ++
      "  <p>Please pay your minimum due amount by the due date to avoid late fees. If you have any questions, contact customer service at 1-800-555-1234.</p>\n" ++
      "</body>\n" ++
      "</html>"

    cssContent = 
      "/* styles.css */\n" ++
      "body {\n" ++
      "  font-family: Arial, sans-serif;\n" ++
      "  margin: 1.25em;\n" ++
      "  line-height: 1.6;\n" ++
      "}\n" ++
      "h1, h2 {\n" ++
      "  text-align: center;\n" ++
      "}\n" ++
      ".info p {\n" ++
      "  margin: 0.3125em 0;\n" ++
      "}\n" ++
      "table {\n" ++
      "  width: 100%;\n" ++
      "  border-collapse: collapse;\n" ++
      "  margin: 1.25em 0;\n" ++
      "}\n" ++
      "th, td {\n" ++
      "  border: 1px solid #ddd;\n" ++
      "  padding: 0.5em;\n" ++
      "}\n" ++
      "th {\n" ++
      "  background-color: red;\n" ++
      "  color: white;\n" ++
      "  text-align: left;\n" ++
      "}\n" ++
      "td strong {\n" ++
      "  font-weight: bold;\n" ++
      "}\n"

    htmlFile = "bill.html"
    cssFile = "styles.css"
    pdfFile = "bill.pdf"


  writeCssToFile cssFile cssContent
  writeHtmlToFile htmlFile htmlContent
  htmlToPdf htmlFile cssFile pdfFile
  putStrLn $ "Successfully converted " ++ htmlFile ++ " to " ++ pdfFile
