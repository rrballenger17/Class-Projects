<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>New Englander</title>
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link href="css/index.css" rel="stylesheet" type="text/css">
</head>

<body>

    <?php include("includes/header.php"); ?>
    
    <?php include("includes/navigation.php"); ?>
   
    <section id="first">
        <div id="intro">
        Expertly crafted clothing for the coastal lifestyle. It's rugged and luxerious. 
        </div>

        <div id="options">
            <h4>Welcome to our store</h4>
            <div>
                <a href="#" onclick="showNewArrivals()" id="nalink" class="linkhere">New Arrivals</a>
                <a href="#" onclick="showCollections()" id="clink" class="linknot">Collections</a>
            </div>
            <span id="newarrivals">
                We've incorporated your feedback into our new arrivals. Some said it wasn't possible, but we've made our clothes even better.
                <br>
                <a href="#">Reinforced Tshirt</a>
                <br>
                <a href="#">Dinner Sweater</a>
                <br>
                <a href="#">Light Pants</a>
                <br>
                <a href="#">Sailing Coat</a>
            </span>
            <span id="collections">
                There's a collection of clothes for every type of day. It's designed to fit your needs whether on the boat or at a wedding. 
                <br>
                <a href="#">Bay and Sailing</a>
                <br>
                <a href="#">Cape Cod</a>
                <br>
                <a href="#">Business Casual</a>
                <br>
                <a href="#">Formal and Celebration</a>
            </span>
        </div>
    </section>
    <section id="second" class="row">
        <hr>
        <h3>Featured Men's</h3>
        <hr>
        <div class="firstitem">
            <a href="itempage.php">
                <img src="images/tshirt.jpg" alt="tshirt">
            </a>
            <span>
                <a href="itempage.php">
                Casual Blue T-shirt
                <br>
                $20
                </a>
            </span>
        </div>
        <div>
            <a href="#">
                <img src="images/bluezipup.jpg" alt="bluezipup">
            </a>
            <span>
                 <a href="#">Zip Sweatshirt
                <br>
                $30</a>
            </span>
        </div>
        <div>
            <a href="#">
                <img src="images/tancoat.jpg" alt="tancoat">
            </a>
            <span>
                 <a href="#">Light Tan Coat
                <br>
                $50</a>
            </span>
        </div>
    </section>
    <section id="third" class="row">
        <hr>
        <h3>Featured Women's</h3>
        <hr>
        <div class="firstitem">
            <a href="#">
                <img src="images/womensgraycoat.jpg" alt="womensgraycoat">
            </a>
            <span>
                <a href="#">Button Coat
                <br>
                $50</a>
            </span>
        </div>
        <div>
            <a href="#"><img src="images/womenstshirt.jpg" alt="womenstshirt"></a>
            <span>
                <a href="#">Casual T-shirt
                <br>
                $20</a>
            </span>
        </div>
        <div>
            <a href="#"><img src="images/browncoat.jpg" alt="browncoat"></a>
            <span>
                <a href="#">Zip Boat Jacket
                <br>
                $50</a>
            </span>
        </div>
    </section>

    <?php include("includes/footer.php"); ?>
   
    <script>
        function showNewArrivals() {
            document.getElementById('newarrivals').style.display = "block";
            document.getElementById('collections').style.display = "none";

            document.getElementById('clink').className = "linknot";
            document.getElementById('nalink').className = "linkhere";
        }

        function showCollections() {
            document.getElementById('newarrivals').style.display = "none";
            document.getElementById('collections').style.display = "block";
            document.getElementById('nalink').className = "linknot";
            document.getElementById('clink').className = "linkhere";
            
        }
    </script>
</body>
</html>
