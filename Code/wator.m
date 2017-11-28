clear;
close all;

map_size = 301;

fish_lifetime_speed = 0.1;
fish_breed_time = 0.5;

shark_lifetime_speed = 0.1;
shark_breed_time = 0.7;
shark_starve_time = 0.3;

M = zeros(map_size,map_size,3); % fish on level 1, sharks on level 2, level 3 is for shark starve time

square_size = 2;
for x = [(map_size+1)/2-square_size:(map_size+1)/2+square_size]
    for y = [(map_size+1)/2-square_size:(map_size+1)/2+square_size]
        M(x,y,1) = 1;
    end
end

M((map_size+1)/2,(map_size+1)/2,2) = 1;
M((map_size+1)/2,(map_size+1)/2,3) = 1;

% create some random fish
%for i = [1:1]
%    rand_x = randi(map_size);
%    rand_y = randi(map_size);
%    while M(rand_x,rand_y,1) > 0
%        rand_x = randi(map_size);
%        rand_y = randi(map_size);
%    end
%    M(rand_x,rand_y,1) = 1;
%end

% create some random sharks
%for i = [1:0]
%    rand_x = randi(map_size);
%    rand_y = randi(map_size);
%    while M(rand_x,rand_y,2) > 0 && M(rand_x,rand_y,2) > 0
%        rand_x = randi(map_size);
%        rand_y = randi(map_size);
%    end
%    M(rand_x,rand_y,2) = 1;
%    M(rand_x,rand_y,3) = 1;
%end

t_fish = [0];
fish_amount = [1];
t_shark = [0];
shark_amount = [1];

for i = [0:10000]
    
    M_new = zeros(map_size,map_size,3);
    
    % first calc fish
    if mod(i,2) == 0
        
        for x = randperm(map_size) % random series used instead of [1:map_size]
            for y = randperm(map_size)

                if M(x,y,1) > 0
                    % decrement life time
                    M(x,y,1) = M(x,y,1) - fish_lifetime_speed;

                    % get empty neighbours
                    [empty_fields,fish] = get_neighbours(M,M_new,x,y);
                    
                    % move to new empty field
                    [fields_amount,dim] = size(empty_fields); % get possible movements length
                    if fields_amount > 0
                        random_direction = randi(fields_amount); % get random direction
                        new_pos = empty_fields(random_direction,:); % get position at random direction
                        M_new(new_pos(1),new_pos(2),1) = M(x,y,1); % move fish

                        empty_fields = [empty_fields(1:random_direction-1,:);empty_fields(random_direction+1:end,:)]; % cut move direction from possible movements

                        % born new fish if breed_time reached
                        if M_new(new_pos(1),new_pos(2),1) < fish_breed_time 
                            M_new(new_pos(1),new_pos(2),1) = 1;

                            [fields_amount,dim] = size(empty_fields); % recalculate length
                            if fields_amount > 0
                                breed_pos = empty_fields(randi(fields_amount),:); % get random direction
                                M_new(breed_pos(1),breed_pos(2),1) = 1;
                            else
                                % M_new(new_pos(1),new_pos(2),1) = fish_breed_time; % don't reset if no new fish is born
                            end
                        end
                    else
                        disp('ERROR fish can not move');
                    end
                else
                    M(x,y,1) = 0; % cap the value always to 0
                end
                
                % copy the shark values
                M_new(x,y,2) = M(x,y,2); 
                M_new(x,y,3) = M(x,y,3);
            end
        end
        
        
    else % then calc sharks
        
        for x = randperm(map_size)
            for y = randperm(map_size)    
            
                if M(x,y,2) > 0
                    
                    % decrement lifetime
                    M(x,y,2) = M(x,y,2) - shark_lifetime_speed;
                    
                    % get neighbours
                    [empty_fields,fish] = get_neighbours(M,M_new,x,y);
                    [fields_amount,dim] = size(empty_fields);
                    
                    new_pos = [x,y];
                    
                    % move to new empty field
                    [fish_fields_amount,dim] = size(fish);
                    if fish_fields_amount > 0
                        M(x,y,3) = 1;
                        new_pos = fish(randi(fish_fields_amount),:); % get position of random random fish
                        % move shark to fish
                        M_new(new_pos(1),new_pos(2),2) = M(x,y,2);
                        M_new(new_pos(1),new_pos(2),3) = M(x,y,3);
                        % the fish dies
                        M(new_pos(1),new_pos(2),1) = 0;
                        M_new(new_pos(1),new_pos(2),1) = 0;
                    else
                        
                        % decrement starve time
                        M(x,y,3) = M(x,y,3) - shark_lifetime_speed;
                        % shark dies if starve time is reached
                        if M(x,y,3) < shark_starve_time
                            M(x,y,2) = 0;
                            M(x,y,3) = 0;
                        end
                        
                        if fields_amount > 0
                            random_direction = randi(fields_amount);
                            new_pos = empty_fields(random_direction,:); % get position at random direction
                            
                            % move shark
                            M_new(new_pos(1),new_pos(2),2) = M(x,y,2); 
                            M_new(new_pos(1),new_pos(2),3) = M(x,y,3); 
                            
                            empty_fields = [empty_fields(1:random_direction-1,:);empty_fields(random_direction+1:end,:)]; % cut move direction from possible movements
                        end
                    end
                    
                    % born new shark if breed_time reached (and the shark is still alive)
                    if M_new(new_pos(1),new_pos(2),2) < shark_breed_time && M_new(new_pos(1),new_pos(2),2) > 0
                        M_new(new_pos(1),new_pos(2),2) = 1;

                        [fields_amount,dim] = size(empty_fields); % recalculate length
                        if fields_amount > 0
                            breed_pos = empty_fields(randi(fields_amount),:); % get random direction
                            % create new shark
                            M_new(breed_pos(1),breed_pos(2),2) = 1;
                            M_new(breed_pos(1),breed_pos(2),3) = M_new(new_pos(1),new_pos(2),3); % starve time should be the same as the parent
                        end
                    end
                    
                    
                end
                
                M_new(x,y,1) = M(x,y,1); % copy the fish value
            end
        end
    end
    
    M = M_new;
    
    % count all fishes and sharks
    count_fish = 0;
    count_sharks = 0;
    for x = [1:map_size]
        for y = [1:map_size]
            if M(x,y,1) > 0
                count_fish = count_fish + 1;
            end
            if M(x,y,2) > 0
                count_sharks = count_sharks + 1;
            end
        end
    end
    
    
    pause(.1);
    subplot(1,2,1);
    image(M);
    
    if (abs(fish_amount(end)-count_fish) > 0.1)
        t_fish(end+1) = i;
        fish_amount(end+1) = count_fish;
        subplot(1,2,2);
        plot(t_shark,shark_amount,t_fish,fish_amount);
    end
    
    if (abs(shark_amount(end)-count_sharks) > 0.1)
        t_shark(end+1) = i;
        shark_amount(end+1) = count_sharks;
        subplot(1,2,2);
        plot(t_shark,shark_amount,t_fish,fish_amount);
    end
end



function [empty_fields, fish] = get_neighbours(M_old,M_new,x,y)

    % left
    l = x-1;
    if l < 1
        l = length(M_old);
    end
    % right
    r = x+1;
    if r > length(M_old)
        r = 1;
    end
    % up
    u = y-1;
    if u < 1
        u = length(M_old);
    end
    % down
    d = y+1;
    if d > length(M_old)
        d = 1;
    end

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
