for slice = (1:23)
    t = tiledlayout(1,3);

    nexttile
    test_u = reshape(U(:,slice,:), [526, 412]);
    %unit = sum(sum(test_u));
    imagesc(test_u)
    colorbar
    title('U slices visualization')
    
    nexttile
    %unit = sum(sum(test_v));
    imagesc(S(:,:,slice))
    colorbar
    title('S slices visualization')

    nexttile
    test_v = reshape(VT(slice,:,:),[575, 412]);
    %unit = sum(sum(test_v));
    imagesc(test_v)
    colorbar
    title('V slices visualization')

    disp(['Displaying slice: ',num2str(slice)])
    input('Press enter to continue...')
end