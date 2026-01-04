<!DOCTYPE html>
<html lang="zh-Hant">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>挖礦與建設遊戲</title>
    <style>
        body {
            margin: 0;
            background: #111;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        canvas {
            border-radius: 12px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <canvas id="game" width="900" height="550"></canvas>

    <script>
        const canvas = document.getElementById("game");
        const ctx = canvas.getContext("2d");

        // 玩家資料
        const player = { x: 400, y: 290, width: 20, height: 20, speed: 4, color: "#4caf50" };

        // 資源資料
        let resources = { stone: 0, wood: 0, gems: 0 };
        let dropCount = 0;  // 記錄掉落的次數
        let items = []; // 儲存掉落的物品

        // 按鍵事件
        const keys = {};
        window.addEventListener("keydown", e => keys[e.key] = true);
        window.addEventListener("keyup", e => keys[e.key] = false);

        // 掉落物品邏輯
        function handleItemDrop() {
            if (keys["ArrowDown"]) {
                dropCount++;

                // 每按 20 次，掉落兩個寶石
                if (dropCount % 20 === 0) {
                    items.push({ x: player.x + 20, y: player.y + 20, color: "#9c27b0", type: "gem" });
                    items.push({ x: player.x + 40, y: player.y + 20, color: "#9c27b0", type: "gem" });
                    resources.gems += 2;
                } else {
                    // 隨機掉落木材或礦石
                    if (Math.random() < 0.5) {
                        items.push({ x: player.x + 20, y: player.y + 20, color: "#8d6e63", type: "wood" });
                        resources.wood += 1;
                    } else {
                        items.push({ x: player.x + 20, y: player.y + 20, color: "#ffeb3b", type: "stone" });
                        resources.stone += 1;
                    }
                }
            }
        }

        // 玩家移動邏輯
        function update() {
            if (keys["ArrowLeft"]) player.x -= player.speed;
            if (keys["ArrowRight"]) player.x += player.speed;
            if (keys["ArrowUp"]) player.y -= player.speed;
            if (keys["ArrowDown"]) player.y += player.speed;

            // 控制玩家在畫布範圍內移動
            player.x = Math.max(0, Math.min(canvas.width - player.width, player.x));
            player.y = Math.max(0, Math.min(canvas.height - player.height, player.y));

            // 處理掉落機制
            handleItemDrop();

            // 更新物品位置，讓物品往下掉落
            items.forEach(item => {
                item.y += 2;  // 物品掉落速度
            });

            // 移除掉出畫布的物品
            items = items.filter(item => item.y < canvas.height);
        }

        // 繪製遊戲畫面
        function draw() {
            ctx.clearRect(0, 0, canvas.width, canvas.height);

            // 繪製像素風格背景
            // 天空
            ctx.fillStyle = "#81d4fa";  // 藍色天空
            ctx.fillRect(0, 0, canvas.width, 200);

            // 土地
            ctx.fillStyle = "#66bb6a";  // 綠色土地
            ctx.fillRect(0, 400, canvas.width, 150);

            // 樹幹 (像素風格)
            ctx.fillStyle = "#6d4c41";
            ctx.fillRect(370, 330, 20, 50);  // 樹幹

            // 樹冠 (像素風格)
            ctx.fillStyle = "#388e3c";
            ctx.beginPath();
            ctx.arc(380, 320, 30, 0, Math.PI * 2); // 樹冠
            ctx.fill();

            // 顯示玩家
            ctx.fillStyle = player.color;
            ctx.fillRect(player.x, player.y, player.width, player.height);

            // 顯示資源
            ctx.fillStyle = "#000";
            ctx.font = "20px sans-serif";
            ctx.fillText("石頭: " + resources.stone, 10, 30);
            ctx.fillText("木材: " + resources.wood, 10, 60);
            ctx.fillText("寶石: " + resources.gems, 10, 90);

            // 顯示掉落物品
            items.forEach(item => {
                ctx.fillStyle = item.color;
                if (item.type === "wood") {
                    ctx.fillRect(item.x, item.y, 10, 10);  // 木材顯示為小方塊
                } else if (item.type === "stone") {
                    ctx.beginPath();
                    ctx.moveTo(item.x, item.y);  // 礦石顯示為金黃色的小方塊
                    ctx.lineTo(item.x + 10, item.y);
                    ctx.lineTo(item.x + 10, item.y + 10);
                    ctx.lineTo(item.x, item.y + 10);
                    ctx.closePath();
                    ctx.fill();
                } else if (item.type === "gem") {
                    ctx.beginPath();
                    ctx.moveTo(item.x, item.y);  // 寶石顯示為紫色小方塊
                    ctx.lineTo(item.x + 10, item.y);
                    ctx.lineTo(item.x + 10, item.y + 10);
                    ctx.lineTo(item.x, item.y + 10);
                    ctx.closePath();
                    ctx.fill();
                }
            });
        }

        // 遊戲循環
        function gameLoop() {
            update();
            draw();
            requestAnimationFrame(gameLoop);
        }

        gameLoop();  // 開始遊戲循環
    </script>
</body>
</html>
