CREATE FUNCTION update_loyalty_points()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$ 
BEGIN
    UPDATE Member m
    SET loyalty_points = loyalty_points + NEW.amount
    WHERE m.member_id = NEW.member_id;
    RETURN NEW;
END;
$$;

CREATE TRIGGER points_after_membership_transation
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE PROCEDURE update_loyalty_points();


CREATE FUNCTION update_membership_expiry()
RETURNS TRIGGER
LANGUAGE plpgsql
AS 
$$ 
BEGIN
    IF 
        (NEW.transaction_type = 'membership renewal') AND (NEW.amount = 50)
    THEN
        IF 
            (SELECT membership_expiry
            FROM Member m
            WHERE m.member_id = NEW.member_id) IS NULL
        THEN 
            UPDATE Member m
            SET membership_expiry = NEW.transaction_date + INTERVAL '1 months'
            WHERE m.member_id = NEW.member_id;
            RETURN NEW;
        END IF;

        UPDATE Member m
        SET membership_expiry = membership_expiry + INTERVAL '1 months'
        WHERE m.member_id = NEW.member_id;
        RETURN NEW;
    END IF;
    RETURN NEW;
END;
$$;


CREATE TRIGGER expiry_after_membership_transation
AFTER INSERT ON Transactions
FOR EACH ROW
EXECUTE PROCEDURE update_membership_expiry();