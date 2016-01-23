<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Casual Tshirt</title>
    <link href="css/style.css" rel="stylesheet" type="text/css">
    <link href="css/itempage.css" rel="stylesheet" type="text/css">

    <!-- jquery --> 
    <script type="text/javascript" src="js/jquery-1.11.2.min.js"></script>  

    <!-- required -->
    <link rel="stylesheet" href="css/jquery.fancybox.css?v=2.1.5" type="text/css" media="screen" />

    <!-- required --> 
    <script type="text/javascript" src="js/jquery.fancybox.pack.js?v=2.1.5"></script>

    <!-- enables scrolling through slideshow with mouse -->
    <script type="text/javascript" src="js/jquery.mousewheel-3.0.6.pack.js"></script>

    <!-- enables thumbs navigation -->
    <link rel="stylesheet" href="css/jquery.fancybox-thumbs.css?v=1.0.7" type="text/css" media="screen" />
    <script type="text/javascript" src="js/jquery.fancybox-thumbs.js?v=1.0.7"></script>

    <script type="text/javascript">
    $(document).ready(function() {
        $(".fancy").fancybox(
        {
            prevEffect  : 'none',
            nextEffect  : 'none',
            autoPlay: true,
            playSpeed: 5000,
            helpers : {
                title   : {
                    type: 'inside'
                },
                thumbs  : {
                    width   : 50,
                    height  : 50
                },
            }
        }
        );
    });
    </script>
</head>

<body>
   
    <?php include("includes/header.php"); ?>

    <?php include("includes/navigation.php"); ?>

    <section id="itemsection">
        <div id="carousel">
            <a class="fancy" rel="alternate" href="images/tshirt.jpg" title="View 1">
                <img src="images/tshirt.jpg" alt="1" id="main" />
            </a>
            <a class="fancy" rel="alternate" href="images/model1.jpg" title="View 2" id="firstthumb">
                <img src="images/model1.jpg" alt="2" />
            </a>
            <a class="fancy" rel="alternate" href="images/model2.jpg" title="View 3">
                <img src="images/model2.jpg" alt="3" />
            </a>
            <a class="fancy" rel="alternate" href="images/model3.jpg" title="View 4">
                <img src="images/model3.jpg" alt="4" />
            </a>
            <a class="fancy" rel="alternate" href="images/model4.jpg" title="View 5">
                <img src="images/model4.jpg" alt="5" />
            </a>
        </div>

        <div id="description">
            <h5>description</h5>
            <div>
                The Casual T-shirt is light and durable. It's perfect for working on the boat or for family dinner on the back porch. 
                <ul>
                    <li> Length to shoulder width proportion: .76</li>
                    <li> Also available in teal, burnt orange, or crimson red</li>
                    <li> 90% cotton, 10% silk </li>
                    <li> Made in Vermont</li>
                </ul>
            </div>
            <br>
            <h5>more information</h5>
            <span>
                Price: $20.00
                <br>
                <br>
                Item number: 8230 4001   
                <br>

                This shirt is <strong>available</strong>
                <br>
                Free shipping on orders over $40.00
                <br>
                Gift wrapping elligible on customer request
            </span>
            <br>
            <br>
            <br>
            <button id="button">Add to Cart</button>
        </div>
    </section>

    <section id="alsobought" class="row">
        <h3>People also bought</h3>
        
        <div class="firstitem">
            <a href="#">
                <img src="images/tanpants.jpg" alt="tanpants">
            </a>
            <span>
                <a href="#">
                Light Boat Pants
                <br>
                $35.00
                </a>
            </span>
        </div>
        <div>
            <a href="#">
                <img src="images/shoe.jpg" alt="shoe">
            </a>

            <span>
                 <a href="#">Backyard water shoe
                <br>
                $55.00</a>
            </span>
        </div>
        <div>
            <a href="#">
                <img src="images/socks.jpeg" alt="socks">
            </a>
            <span>
                 <a href="#">Country Club Socks
                <br>
                $8.00</a>
            </span>
        </div>
    </section>
   
    <?php include("includes/footer.php"); ?>

    <script>
        document.getElementById("checkoutNav").style.display = "none";
        document.getElementById("men_li").className = "youarehere";

        document.getElementById("button").onclick = function () {
            location.href = "checkout.php";
        };
    </script>
</body>
</html>