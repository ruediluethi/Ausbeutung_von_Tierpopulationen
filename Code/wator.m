clear;
close all;

cycle_time = 1;
cycles = [0];
max_shown_cycles = 500/cycle_time;

%map_size = 256;

%fish_lifetime_speed = 0.05;
%fish_breed_time = 0.7;

%shark_lifetime_speed = 0.025;
%shark_breed_time = 0.8;
%shark_starve_time = 0.2;

map_size = 128;

fish_lifetime_speed = 0.1;
fish_breed_time = 0.7;

shark_lifetime_speed = 0.05;
shark_breed_time = 0.5;
shark_starve_time = 0.2;

M = zeros(map_size,map_size,4); % fish on level 1, sharks on level 2, level 3 is for shark starve time, level 4 for blood particle

% create random fish/shark cells
square_size = 1;
%{
for i = [1:3]

    rand_x = randi(map_size-square_size*2)+square_size;
    rand_y = randi(map_size-square_size*2)+square_size;

    for x = [rand_x-square_size:rand_x+square_size]
        for y = [rand_y-square_size:rand_y+square_size]
            M(x,y,1) = 1;
        end
    end

    M(rand_x,rand_y,1) = 0;
    M(rand_x,rand_y,2) = 1;
    M(rand_x,rand_y,3) = 1;

end
%}
%M(map_size/2,map_size/2,1) = 1;

% create some random fish
for t = [1:map_size]
    rand_x = randi(map_size);
    rand_y = randi(map_size);
    while M(rand_x,rand_y,1) > 0
        rand_x = randi(map_size);
        rand_y = randi(map_size);
    end
    M(rand_x,rand_y,1) = fish_breed_time + (1-fish_breed_time)*rand();
end

% create some random sharks
for t = [1:map_size]
    rand_x = randi(map_size);
    rand_y = randi(map_size);
    while M(rand_x,rand_y,2) > 0 && M(rand_x,rand_y,2) > 0
        rand_x = randi(map_size);
        rand_y = randi(map_size);
    end
    M(rand_x,rand_y,2) = shark_breed_time + (1-shark_breed_time)*rand();
    M(rand_x,rand_y,3) = shark_starve_time + (1-shark_starve_time)*rand();
end


fish_amount = [map_size];
shark_amount = [map_size];
img_counter = 1;

for t = [0:100000]
    
    M_new = zeros(map_size,map_size,4);
    
    % first calc fish
    if mod(t,3) == 0
        
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
                        %if M_new(new_pos(1),new_pos(2),1) < fish_breed_time*rand() 
                        if M_new(new_pos(1),new_pos(2),1) < fish_breed_time
                            M_new(new_pos(1),new_pos(2),1) = fish_breed_time + (1-fish_breed_time)*rand();

                            [fields_amount,dim] = size(empty_fields); % recalculate length
                            if fields_amount > 0
                                breed_pos = empty_fields(randi(fields_amount),:); % get random direction
                                M_new(breed_pos(1),breed_pos(2),1) = fish_breed_time + (1-fish_breed_time)*rand();
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
                % copy blood
                M_new(x,y,4) = M(x,y,4); 
            end
        end
        
    elseif mod(t,3) == 1 % then calc sharks
        
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
                        M(x,y,3) = shark_starve_time + (1-shark_starve_time)*rand();
                        new_pos = fish(randi(fish_fields_amount),:); % get position of random random fish
                        % move shark to fish
                        M_new(new_pos(1),new_pos(2),2) = M(x,y,2);
                        M_new(new_pos(1),new_pos(2),3) = M(x,y,3);
                        % the fish dies
                        M(new_pos(1),new_pos(2),1) = 0;
                        M_new(new_pos(1),new_pos(2),1) = 0;
                        % create blood particle
                        M(new_pos(1),new_pos(2),4) = 1;
                    else
                        
                        % decrement starve time
                        M(x,y,3) = M(x,y,3) - shark_lifetime_speed;
                        % shark dies if starve time is reached
                        %if M(x,y,3) < shark_starve_time*rand()
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
                    %if M_new(new_pos(1),new_pos(2),2) < shark_breed_time*rand() && M_new(new_pos(1),new_pos(2),2) > 0
                    if M_new(new_pos(1),new_pos(2),2) < shark_breed_time && M_new(new_pos(1),new_pos(2),2) > 0
                        M_new(new_pos(1),new_pos(2),2) = shark_breed_time + (1-shark_breed_time)*rand();

                        [fields_amount,dim] = size(empty_fields); % recalculate length
                        if fields_amount > 0
                            breed_pos = empty_fields(randi(fields_amount),:); % get random direction
                            % create new shark
                            M_new(breed_pos(1),breed_pos(2),2) = shark_breed_time + (1-shark_breed_time)*rand();
                            M_new(breed_pos(1),breed_pos(2),3) = M_new(new_pos(1),new_pos(2),3); % starve time should be the same as the parent
                        end
                    end
                    
                    
                end
                
                M_new(x,y,1) = M(x,y,1); % copy the fish value
                M_new(x,y,4) = M(x,y,4); % copy blood
            end
        end
        
        
    else % do blood
        
        M(:,:,4) = M(:,:,4)*0.98;
        
        for x = randperm(map_size) % random series used instead of [1:map_size]
            for y = randperm(map_size)
                M_new(x,y,1) = M(x,y,1); % copy the fish value
                M_new(x,y,2) = M(x,y,2); % copy the shark values
                M_new(x,y,3) = M(x,y,3);
                
                % blood flow
                %blood_value = M(x,y,4) / 5;
                
                l = mod(x-2,length(M))+1;
                r = mod(x,length(M))+1;
                u = mod(y-2,length(M))+1;
                d = mod(y,length(M))+1;
                
                diffuse_factor = 0.1;
                blood_value = M(x,y,4);
                blood_value = blood_value + (M(l,y,4) - M(x,y,4))*diffuse_factor;
                blood_value = blood_value + (M(r,y,4) - M(x,y,4))*diffuse_factor;
                blood_value = blood_value + (M(x,u,4) - M(x,y,4))*diffuse_factor;
                blood_value = blood_value + (M(x,d,4) - M(x,y,4))*diffuse_factor;
                
                M_new(x,y,4) = blood_value;
                
                %M_new(x,y,4) = M_new(x,y,4) + blood_value;
                %M_new(l,y,4) = M_new(l,y,4) + blood_value;
                %M_new(r,y,4) = M_new(r,y,4) + blood_value;
                %M_new(x,u,4) = M_new(x,u,4) + blood_value;
                %M_new(x,d,4) = M_new(x,d,4) + blood_value;
            end
        end
    end
    
    M = M_new;
    
    
    if mod(t,cycle_time*3) == 2
        
        % count all fishes and sharks
        count_fish = 0;
        count_sharks = 0;

        output = zeros(map_size,map_size,3);
        % background color
        r = 0.368;
        g = 0.643;
        b = 0.8;
        % greyscale
        %r = 0.5;
        %g = 0.5;
        %b = 0.5;
        
        round(r*256)
        round(g*256)
        round(b*256)
        
        % blood color (only for visual effect)
        br = 0.8;
        bg = 0;
        bb = 0;
        % greyscale
        %br = 0.5;
        %bg = 0.5;
        %bb = 0.5;

        for x = [1:map_size]
            for y = [1:map_size]
                
                %blood_value = M(x,y,4);
                %blood_value = cos(blood_value*pi+pi)/2+0.5; % more contrast
                blood_value = 0;
                tr = r + (br-r)*blood_value;
                tg = g + (bg-r)*blood_value;
                tb = b + (bb-r)*blood_value;
                
                if M(x,y,1) > 0
                    count_fish = count_fish + 1;
                    output(x,y,1) = tr+(1-tr)*M(x,y,1);
                    output(x,y,2) = tg+(1-tg)*M(x,y,1);
                    output(x,y,3) = tb+(1-tb)*M(x,y,1);
                elseif M(x,y,2) > 0
                    count_sharks = count_sharks + 1;
                    output(x,y,1) = tr*(1-M(x,y,3));
                    output(x,y,2) = tg*(1-M(x,y,3));
                    output(x,y,3) = tb*(1-M(x,y,3));
                else
                    output(x,y,1) = tr;
                    output(x,y,2) = tg;
                    output(x,y,3) = tb;
                end 
            end
        end
    
        %subplot(1,2,1);
        image(output);
        imwrite(output,['/Users/ruedi/Outputs/wator_image_',num2str(img_counter),'.png']);
        img_counter = img_counter+1;
        
        cycles(end+1) = t/3;
        fish_amount(end+1) = count_fish;
        shark_amount(end+1) = count_sharks;
        
        %{
        subplot(1,3,2);
        plot(cycles,fish_amount,cycles,shark_amount);
        legend('fishes','sharks');
        xlabel('cycles');
        ylabel('population');
        %}
        
        %subplot(1,2,2);
        plot(cycles,fish_amount,'k',cycles,shark_amount,'k--');
        axis([ min(cycles) max(cycles) 0 max(max(fish_amount),max(shark_amount)) + min(min(fish_amount),min(shark_amount)) ]);
        legend('Fische','Haie');
        legend('boxoff');
        legend('Location','northoutside');
        xlabel('Zyklen');
        ylabel('Anzahl Tiere');
        fig = gcf;
        fig.PaperUnits = 'centimeters';
        fig.PaperPosition = [0 0 7 7];
        print(['/Users/ruedi/Outputs/wator_diagram_',num2str(img_counter),'.png'],'-dpng','-r300');
        
        %subplot(1,3,3);
        %plot(fish_amount,shark_amount,'k');
        %xlabel('fishes');
        %ylabel('sharks');
        
        % cut the diagram to max_shown_cycles
        if length(cycles) > max_shown_cycles
            cycles = cycles(end-max_shown_cycles:end);
            fish_amount = fish_amount(end-max_shown_cycles:end);
            shark_amount = shark_amount(end-max_shown_cycles:end);
        end
        
        pause(.1);
    end
end
