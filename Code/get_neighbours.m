function [empty_fields, fish] = get_neighbours(M_old,M_new,x,y)

    % left
    l = mod(x-2,length(M_old))+1;
    
    % right
    r = mod(x,length(M_old))+1;
    
    % up
    u = mod(y-2,length(M_old))+1;
    
    % down
    d = mod(y,length(M_old))+1;
    
    % center
    empty_fields = [x,y];
    fish = [];
    
    % left
    if M_old(l,y,1) > 0
        fish = [fish;[l,y]];
    else
        % no fish, no shark, not before, not after
        if not(M_old(l,y,1) > 0) && not(M_new(l,y,1) > 0) && not(M_old(l,y,2) > 0) && not(M_new(l,y,2) > 0)
            empty_fields = [empty_fields;[l,y]];
        end
    end
    
    % right
    if M_old(r,y,1) > 0
        fish = [fish;[r,y]];
    else
        if not(M_old(r,y,1) > 0) && not(M_new(r,y,1) > 0) && not(M_old(r,y,2) > 0) && not(M_new(r,y,2) > 0)
            empty_fields = [empty_fields;[r,y]];
        end
    end
    % up
    if M_old(x,u,1) > 0
        fish = [fish;[x,u]];
    else
        if not(M_old(x,u,1) > 0) && not(M_new(x,u,1) > 0) && not(M_old(x,u,2) > 0) && not(M_new(x,u,2) > 0)
            empty_fields = [empty_fields;[x,u]];
        end
    end
    % down
    if M_old(x,d,1) > 0
        fish = [fish;[x,d]];
    else
        if not(M_old(x,d,1) > 0) && not(M_new(x,d,1) > 0) && not(M_old(x,d,2) > 0) && not(M_new(x,d,2) > 0)
            empty_fields = [empty_fields;[x,d]];
        end
    end
end