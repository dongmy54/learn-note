## 存储过程
```
DELIMITER //

CREATE PROCEDURE generate_test_data(IN num_rows INT)
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE random_kind INT;
    DECLARE random_receiver_id VARCHAR(50);
    DECLARE random_content JSON;
    -- 随机eventType
    DECLARE str_count INT;
    DECLARE random_index INT;
    DECLARE random_event_type VARCHAR(255);
    -- 正确定义 EventType 数组，注意使用正确的逗号分隔
    DECLARE event_types VARCHAR(500) DEFAULT 'EventGroupApply,EventGroupApplyPass,EventGroupApplyReject,EventGroupQuit,EventGroupDismiss,EventGroupDisband,EventPatientDelete,EventBillAutoPay,EventCaseStates';
    -- 声明一个变量用于存储随机数
    DECLARE random_num INT;

    -- 将字符串列表按逗号分隔，并计算字符串的数量
    SET str_count = LENGTH(event_types) - LENGTH(REPLACE(event_types, ',', '')) + 1;

    -- 生成一个随机索引（从1到str_count）
    SET random_index = FLOOR(1 + RAND() * str_count);

    -- 使用SUBSTRING_INDEX函数获取随机索引对应的字符串
    SET random_event_type = SUBSTRING_INDEX(SUBSTRING_INDEX(event_types, ',', random_index), ',', -1);

    WHILE i <= num_rows DO
        SET random_kind = FLOOR(RAND() * 3) + 1; -- 随机生成 1, 2, 3

        -- 生成 100000 以内的随机数
        SET random_num = FLOOR(RAND() * 100000);

        -- 将 'abc' 和随机数连接成字符串
        SET random_receiver_id = CONCAT('abc', random_num);

        SET random_content = JSON_OBJECT('message', CONCAT('Test message ', i)); -- 随机生成 JSON 内容

        INSERT INTO t_df_message (id, Kind, EventId, EventType, SenderId, ReceiverId, Content, Status, OpStatus)
        VALUES (UUID(), random_kind, UUID(), random_event_type, UUID(), random_receiver_id, random_content, FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 2) + 1);

        SET i = i + 1;
    END WHILE;
END //

DELIMITER ;
```


`CALL generate_test_data(100000);`



