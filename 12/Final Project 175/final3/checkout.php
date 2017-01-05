<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Check out</title>
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link href="css/checkout.css" rel="stylesheet" type="text/css">

    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.3/jquery.min.js"
    type="text/javascript"></script>
    <script type="text/javascript"
    src="http://ajax.microsoft.com/ajax/jquery.validate/1.14.0/jquery.validate.min.js">
    </script>
    <script type="text/javascript">
        $(document).ready(function(){
        var validation = $("#myForm").validate(
            {
            rules: { 
                first_name: { required: true, minlength: 2 },
                last_name: { required: true, minlength: 2 },
                email: { required: true, email: true },
                p_zip: { required: true, minlength: 5, maxlength: 5, number: true },
                credit: {required: true, minlength: 16, maxlength: 16, number: true},

                creditfullname: {required: true, minlength: 2},

                payzip: { required: true, minlength: 5, maxlength: 5, number: true },

                s_fullname: {required: true, minlength: 2},
                s_zip: { required: true, minlength: 5, maxlength: 5, number: true },

            }
     
            });
        });
    </script>
</head>

<body>
     
    <?php include("includes/header.php"); ?>

    <?php include("includes/navigation.php"); ?>
   
    <section id="checkout">
        <form id="myForm" method="post" action="http://cscie12.dce.harvard.edu/echo" enctype="application/x-www-form-urlencoded">

        <h5>Cart</h5>
            <img src="images/tshirt.jpg" alt="tshirt">
            <span>
                Casual Tshirt
            </span>
            <span>
                Quantity: 1
            </span>
            <span>
                Color: 
                <select name="color">
                    <option value="blue">blue</option>
                    <option value="burnt orange">burnt orange</option>
                    <option value="crimson red">crimson red</option>
                </select>
            </span>
            <span>
                Size: 
                <select name="size">
                    <option value="small">small</option>
                    <option value="medium">medium</option>
                    <option value="large">large</option>
                    <option value="xlarge">x large</option>
                </select>
            </span>
            <span>
                Total: $24.00
            </span>
        <br>
        <br>
        <fieldset id="firstfieldset">
            <legend>Personal Information</legend>
            <p>Already registered? <a href="#">Login</a></p>
            <br>
            <br>
            <label for="first_name">First Name</label>
            <br>
            <input type="text" id="first_name" name="first_name">
            <br>
            <br>
            <label for="last_name">Last Name</label>
            <br>
            <input type="text" id="last_name" name="last_name">
            <br>
            <br>
            <label for="email">Email Address</label>
            <br>
            <input type="text" id="email" name="email">
            <br>
            <br>
            <label for="p_address">Address</label>
            <br>
            <input type="text" id="p_address" name="p_address" class="required">
            <br>
            <br>
            <label for="p_city">City</label>
            <br>
            <input type="text" id="p_city" name="p_city" class="required">
            <br>
            <br>
            <label for="p_state">State</label>
            <br>
            <input type="text" id="p_state" name="p_state" class="required">
            <br>
            <br>
            <label for="p_zip">Zip Code</label>
            <br>
            <input type="text" id="p_zip" name="p_zip">
            <br>
            <br>
        </fieldset>

        <fieldset>
            <legend>Payment Information</legend>
            <label for="credit">Credit Card Number</label>
            <br>
            <input type="text" id="credit" name="credit" class="required">
            <br>
            <br>
            <div>Card Type</div>
            <select name="cardtype">
                <option value="mastercard">MasterCard</option>
                <option value="Visa">Visa</option>
                <option value="Discover">Discover</option>
                <option value="americanexpress">American Express</option>
            </select>
            <br>
            <br>
            <label for="creditfullname">Full Name (as on credit card)</label>
            <br>
            <input type="text" id="creditfullname" name="creditfullname" class="required">
            <br>
            <br>
            
            <input type="checkbox" id="cdiff" name="cdiff" value="cdiff" onclick="togglePAddress();">
            <label for="cdiff">Payment address is different than above</label>
            <br>
            <br>
            <div id="pAdditional">
                <label for="payaddress">Address</label>
                <br>
                <input type="text" id="payaddress" name="payaddress" class="required">
                <br>
                <br>
                <label for="paycity">City</label>
                <br>
                <input type="text" id="paycity" name="paycity" class="required">
                <br>
                <br>
                <label for="paystate">State</label>
                <br>
                <input type="text" id="paystate" name="paystate" class="required">
                <br>
                <br>
                <label for="payzip">Zip Code</label>
                <br>
                <input type="text" id="payzip" name="payzip">
                <br>
                <br>
            </div>
        </fieldset>

        <fieldset>
            <legend>Shipping Information</legend>
            <br>
            <input type="checkbox" id="sdiff" name="sdiff" value="sdiff" onclick="toggleSAddress();">
            <label for="sdiff">Shipping address is different than the first listed address</label>
            <br>
            <br>
            <div id="sAdditional">
                <label for="s_fullname">Full Name</label>
                <br>
                <input type="text" id="s_fullname" name="s_fullname" class="required">
                <br>
                <br>
                <label for="s_address">Address</label>
                <br>
                <input type="text" id="s_address" name="s_address" class="required">
                <br>
                <br>
                <label for="s_city">City</label>
                <br>
                <input type="text" id="s_city" name="s_city" class="required">
                <br>
                <br>
                <label for="s_state">State</label>
                <br>
                <input type="text" id="s_state" name="s_state" class="required">
                <br>
                <br>
                <label for="s_zip">Zip Code</label>
                <br>
                <input type="text" id="s_zip" name="s_zip">
                <br>
                <br>
            </div>
            <input type="checkbox" id="gift" name="gift" value="gift">
            <label for="gift">Wrap in gift box</label>
            <br>
            <br>
        </fieldset>

        <fieldset>
            <legend>Customer Information (optional)</legend>
            <div>Would you like to receive email or fliers?</div>
            <input type="radio" id="emailcontact" name="mail" value="emailcontact">
            <label for="emailcontact">Yes, email only please.</label>
            <br>
            <input type="radio" id="fliers" name="mail" value="fliers">
            <label for="fliers">Yes, fliers only please.</label>
            <br>
            <input type="radio" id="bothEmailFlier" name="mail" value="bothEmailFlier">
            <label for="bothEmailFlier">Yes, both! I love New Englander.</label>
            <br>
            <input type="radio" id="neither" name="mail" value="neither">
            <label for="neither">No, thanks.</label>
            <br>
            <br>
            <div>How'd you learn about New Englander?</div>
            <select name="hear">
                <option value="na" selected="selected" id="default">Please choose one</option>
                <optgroup label="Marketing">
                    <option value="onlinead">Online Ad</option>
                    <option value="billboard">Billboard</option>
                    <option value="tvcommercial">TV commercial</option>
                    <option value="flyerMail">Flyer or mail</option>
                </optgroup>
                <optgroup label="Referral">
                    <option value="saw">Saw someone wearing NE</option>
                    <option value="heard">Heard about NE from someone</option>
                    <option value="gift">You've recieved NE merchandise as a gift</option>
                </optgroup>
            </select>
            <br>
            <br>
        </fieldset>
         
        <input type="submit" value="Place Order" id="placeOrder">
        <br>
        <br>
    </form> 
    </section>
   
    <?php include("includes/footer.php"); ?>

    <script>
        document.getElementById("men_li").className = "youarehere";

        function togglePAddress() {
            if(document.getElementById('cdiff').checked)
                document.getElementById('pAdditional').style.display = "block";
            else
                document.getElementById('pAdditional').style.display = "none";
        }

        function toggleSAddress() {
            if(document.getElementById('sdiff').checked)
                document.getElementById('sAdditional').style.display = "block";
            else
                document.getElementById('sAdditional').style.display = "none";
        }
    </script>
</body>
</html>