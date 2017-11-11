<script>


    // 初始化样式
    initCss();

    // 初始化头像点击
    initAvatarOnclick();

    initUsernameOnclick();

    initCellOnClick();

    
{
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
            avatars[i].onclick = function(event){

                var html = this.parentNode.parentNode.innerHTML;

                //window.location.href= "userId://" + html.match(/member\/(\S*)\"/)[1];
                window.webkit.messageHandlers.WTUsernameDidClickAppName.postMessage(html.match(/member\/(\S*)\"/)[1]);
                event.stopPropagation();
            }
        }
    }

    function initUsernameOnclick()
    {
        var usernames = document.getElementsByClassName("dark");
        for(var i = 0; i < usernames.length; i++)
        {
            usernames[i].onclick = function(event){


                this.href = "javascript:;";
                //window.location.href= "userId://" + this.innerHTML;
                window.webkit.messageHandlers.WTUsernameDidClickAppName.postMessage(this.innerHTML);
                event.stopPropagation();
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
                    var thank_area = this.getElementsByClassName("thank_area")[0];
                    // onclick="if (confirm('&#x786E;&#x5B9A;&#x8981;&#x5411; aqutor &#x53D1;&#x9001;&#x611F;&#x8C22;&#xFF1F;')) { thankReply(4952660, 'lhwhugrpctgkkicrhqvkcpcljmwxflxk'); }" 
                    var thankParam = thank_area.innerHTML.match("[a-z]{10,}");
                    var thankId = thank_area.innerHTML.match("[0-9]{7,}");
                    window.webkit.messageHandlers.WTItemCellDidClickAppName.postMessage(dark.innerHTML+","+thankId + "?t="+thankParam);
                }
            }

        }
    }

    var topic_content_images = document.getElementsByClassName("topic_content").getElementsByTagName("img");
    var topic_content_imagesArray = [];
    for (var i = 0; i < topic_content_images.length; i++)
    {
        var imgs = reply_content[i].getElementsByTagName("img");
        topic_content_imagesArray.concat(imgs);
    }
    //
    var reply_content = document.getElementsByClassName("reply_content");
   
    for(var i = 0; i < reply_content.length; i++)
    {
        var imgs = reply_content[i].getElementsByTagName("img");
        topic_content_imagesArray.concat(imgs);
    }
    //
    contentImageClick(topic_content_imagesArray);
    //
    function contentImageClick(images)
    {
        for(var i = 0; i < images.length; i++)
        {
            images[i].index = i;
            images[i].onclick = function(event){

                var parentNode = this.parentNode;
                if (parentNode.href != undefined)
                {
                    parentNode.href="javascript:;";
                    parentNode.target = "";
                }

                var imagesUrl = "";

                if (images.length == 1)
                {
                    //window.location.href="images://--" + this.src+"--";
                    event.stopPropagation();
                    alert("images://--" + this.src+"--");
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
                event.stopPropagation();
                //window.location.href="images://" + imagesUrl;                
                alert("images://" + imagesUrl);
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

</script>
