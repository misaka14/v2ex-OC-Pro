<script>

    // 初始化样式
    initCss();
    // 初始化头像点击
    initAvatarOnclick();

    initUsernameOnclick();

    initCellOnClick();

    if ('addEventListener' in document)
    {
        document.addEventListener('DOMContentLoaded', function(){
                FastClick.attach(document.body);
        }, false);
    }

    function initAvatarOnclick()
    {
        var avatars = document.getElementsByClassName("avatar");

        for (var i = 0; i < avatars.length; i++)
        {
            avatars[i].onclick = function(){

                var html = this.parentNode.parentNode.innerHTML;

                window.location.href= "userId://" + html.match(/member\/(\S*)\"/)[1];

                getEvent().stopPropagation();
            }
        }
    }

    function initUsernameOnclick()
    {
        var usernames = document.getElementsByClassName("dark");
        for(var i = 0; i < usernames.length; i++)
        {
            usernames[i].onclick = function(){


                this.href = "javascript:;";
                window.location.href= "userId://" + this.innerHTML;

                getEvent().stopPropagation();
            }
        }
    }

    function initCellOnClick()
    {
        var cells = document.getElementsByClassName("cell");

        for (var i = 0; i < cells.length; i++)
        {
            if (cells[i].hasAttribute("id"))
            {
                cells[i].onclick = function(){

                    var dark = this.getElementsByClassName("dark")[0];
                    window.location.href= "replyusername://@" + dark.innerHTML;
                }
            }

        }
    }

    var topic_content_images = document.getElementsByClassName("topic_content")[0].getElementsByTagName("img");
    //
    var reply_content = document.getElementsByClassName("reply_content");
   
    for(var i = 0; i < reply_content.length; i++)
    {
        contentImageClick(reply_content[i].getElementsByTagName("img"));
    }
    //
    contentImageClick(topic_content_images);
    //    contentImageClick(reply_content_images);
    //
    function contentImageClick(images)
    {
        for(var i = 0; i < images.length; i++)
        {
            images[i].index = i;
            images[i].onclick = function(){

                var parentNode = this.parentNode;
                if (parentNode.href != undefined)
                {
                    parentNode.href="javascript:;";
                    parentNode.target = "";
                }

                var imagesUrl = "";

                if (images.length == 1)
                {
                    window.location.href="images://--" + this.src+"--";
                    return;
                }

                for(var j = 0; j < images.length; j++)
                {
                    if(this.index == j)
                    {
                        imagesUrl += "::--" + images[j].src + "--";
                    }
                    else
                    {
                        imagesUrl += "::" + images[j].src;
                    }

                }
                getEvent().stopPropagation();
                window.location.href="images://" + imagesUrl;
            }
        }
    }



    function initCss()
    {
        var topic_content = document.getElementsByClassName("topic_content")[0];
        var markdown_body = topic_content.getElementsByClassName("markdown_body");
        if (markdown_body.length == 0)
        {
            topic_content.style.padding = "10px";
        }
    }
       

    function getEvent() {
        if (document.all) {
            return window.event; //如果是ie
        }
        func = getEvent.caller;
        while (func != null) {
            var arg0 = func.arguments[0];
            if (arg0) {
                if ((arg0.constructor == Event || arg0.constructor == MouseEvent) || (typeof(arg0) == "object" && arg0.preventDefault && arg0.stopPropagation)) {
                    return arg0;
                }
            }
            func = func.caller;
        }
        return null;
    }                                                        
                                                               

    window.onload = function(){

        $('a').on('click touchend', function(e) {  
          var el = $(this);  
          var link = el.attr('href');  
          window.location = link;  
       });



    }



</script>
